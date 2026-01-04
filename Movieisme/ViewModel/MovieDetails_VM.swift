//
//  MovieDetailsViewModel.swift
//  Movieisme
//

import Foundation
import Combine

@MainActor
class MovieDetailsViewModel: ObservableObject {
    @Published var movie: Movie?
    @Published var director: Director?
    @Published var actors: [Actor] = []
    @Published var reviews: [MovieReview] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLoadingReviews = false
    
    var averageRating: Double {
        guard !reviews.isEmpty else { return 0.0 }
        let sum = reviews.reduce(0) { $0 + $1.rating }
        return Double(sum) / Double(reviews.count)
    }
    
    func loadMovie(id: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Fetch movie details
            try await fetchMovie(id: id)
            
            // Fetch related data in parallel
            async let directorTask = fetchDirector(movieID: id)
            async let actorsTask = fetchActors(movieID: id)
            async let reviewsTask = loadReviews(movieID: id)
            
            _ = try await (directorTask, actorsTask, reviewsTask)
            
        } catch {
            errorMessage = "Failed to load movie: \(error.localizedDescription)"
            print("Error loading movie: \(error)")
        }
        
        isLoading = false
    }
    
    private func fetchMovie(id: String) async throws {
        let urlString = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movies/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(APIKey.airtable)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("Movie fetch status code: \(httpResponse.statusCode)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let movieRecord = try JSONDecoder().decode(MovieRecord.self, from: data)
        self.movie = movieRecord.fields
    }
    
    private func fetchDirector(movieID: String) async throws {
        let urlString = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/directors"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(APIKey.airtable)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        struct DirectorResponse: Codable {
            let records: [DirectorRecord]
        }
        
        struct DirectorRecord: Codable {
            let id: String
            let fields: DirectorFields
        }
        
        struct DirectorFields: Codable {
            let name: String
            let image: String
            let movie_id: [String]?
        }
        
        let directorResponse = try JSONDecoder().decode(DirectorResponse.self, from: data)
        
        // Find director for this movie
        if let directorRecord = directorResponse.records.first(where: { record in
            record.fields.movie_id?.contains(movieID) ?? false
        }) {
            self.director = Director(
                name: directorRecord.fields.name,
                image: directorRecord.fields.image
            )
        }
    }
    
    private func fetchActors(movieID: String) async throws {
        let urlString = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/actors"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(APIKey.airtable)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        struct ActorResponse: Codable {
            let records: [ActorRecord]
        }
        
        struct ActorRecord: Codable {
            let id: String
            let fields: ActorFields
        }
        
        struct ActorFields: Codable {
            let name: String
            let image: String
            let movie_id: [String]?
        }
        
        let actorResponse = try JSONDecoder().decode(ActorResponse.self, from: data)
        
        // Filter actors for this movie
        let movieActors = actorResponse.records
            .filter { $0.fields.movie_id?.contains(movieID) ?? false }
            .map { Actor(name: $0.fields.name, image: $0.fields.image) }
        
        self.actors = movieActors
    }
    
    func loadReviews(movieID: String) async {
        isLoadingReviews = true
        print("🔄 Loading reviews for movie: \(movieID)")
        
        do {
            var allReviewRecords: [ReviewRecord] = []
            var offset: String? = nil
            
            // Pagination loop to fetch all reviews
            repeat {
                // For linked record fields in Airtable, we need to use FIND() to search in arrays
                var urlString = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/reviews?filterByFormula=FIND('\(movieID)',ARRAYJOIN({movie_id}))"
                
                // Add offset parameter if we have one (for pagination)
                if let offset = offset {
                    urlString += "&offset=\(offset)"
                }
                
                guard let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                      let url = URL(string: encodedURL) else {
                    throw URLError(.badURL)
                }
                
                var request = URLRequest(url: url)
                request.setValue("Bearer \(APIKey.airtable)", forHTTPHeaderField: "Authorization")
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("❌ Reviews fetch failed with status: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                    throw URLError(.badServerResponse)
                }
                
                struct ReviewResponse: Codable {
                    let records: [ReviewRecord]
                    let offset: String?
                }
                
                let reviewResponse = try JSONDecoder().decode(ReviewResponse.self, from: data)
                print("✅ Found \(reviewResponse.records.count) reviews in this batch")
                
                allReviewRecords.append(contentsOf: reviewResponse.records)
                offset = reviewResponse.offset // This will be nil if there are no more pages
                
            } while offset != nil
            
            print("✅ Total reviews fetched: \(allReviewRecords.count)")
            
            // Fetch user details for each review
            var movieReviews: [MovieReview] = []
            var failedUserFetches = 0
            
            for (index, reviewRecord) in allReviewRecords.enumerated() {
                print("📝 [\(index + 1)/\(allReviewRecords.count)] Processing review: \(reviewRecord.id)")
                
                // Get the first user_id from the array (Airtable returns linked records as arrays)
                let userIDString = reviewRecord.fields.user_id
                guard !userIDString.isEmpty else {
                    print("   ⚠️ Empty user_id in review")
                    failedUserFetches += 1
                    continue
                }

                
                print("   User ID: \(userIDString)")
                print("   Rating: \(reviewRecord.fields.rate)")
                print("   Text preview: \(String(reviewRecord.fields.review_text.prefix(50)))...")
                
                do {
                    if let user = try await fetchUser(userID: userIDString) {
                        let movieReview = MovieReview(
                            id: reviewRecord.id,
                            author: user.name,
                            authorImage: user.profile_image,
                            text: reviewRecord.fields.review_text,
                            rating: reviewRecord.fields.rate
                        )
                        movieReviews.append(movieReview)
                        print("   ✅ Successfully added review from: \(user.name)")
                    } else {
                        failedUserFetches += 1
                        print("   ⚠️ User returned nil for ID: \(userIDString)")
                    }
                } catch {
                    failedUserFetches += 1
                    print("   ❌ Error fetching user: \(error.localizedDescription)")
                }
            }
            
            print("✅ Successfully loaded \(movieReviews.count) complete reviews")
            if failedUserFetches > 0 {
                print("⚠️ Failed to fetch user data for \(failedUserFetches) reviews")
            }
            self.reviews = movieReviews
            
        } catch {
            print("❌ Error loading reviews: \(error)")
        }
        
        isLoadingReviews = false
    }
    
    private func fetchUser(userID: String) async throws -> User? {
        let urlString = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/users/\(userID)"
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL for user: \(userID)")
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(APIKey.airtable)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response for user: \(userID)")
                return nil
            }
            
            print("   User fetch status: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("   ❌ User fetch failed with status \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("   Response: \(responseString)")
                }
                return nil
            }
            
            let userRecord = try JSONDecoder().decode(UserRecord.self, from: data)
            print("   ✅ User found: \(userRecord.fields.name)")
            return userRecord.fields
        } catch {
            print("   ❌ Exception fetching user \(userID): \(error)")
            throw error
        }
    }
}
