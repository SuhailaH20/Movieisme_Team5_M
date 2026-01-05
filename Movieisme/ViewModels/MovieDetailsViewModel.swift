
import SwiftUI
import Combine

@MainActor
class MovieDetailsViewModel: ObservableObject {
    @Published var movie: Movie?
    @Published var director: Director?
    @Published var actors: [Actor] = []
    @Published var reviews: [MovieReview] = []
    
    @Published var isLoading = false
    @Published var isLoadingReviews = false
    @Published var errorMessage: String?

    var averageRating: Double {
        guard !reviews.isEmpty else { return 0.0 }
        let sum = reviews.reduce(0) { $0 + $1.rating }
        let average = Double(sum) / Double(reviews.count)
        
        // out of 5
        return min(average, 5.0)
    }

    func loadMovie(id: String) async {
        isLoading = true
        errorMessage = nil

        do {
            // load movie details
            let movieURL = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movies/\(id)")!
            let movieData = try await APIClient.fetch(movieURL)
            let record = try JSONDecoder().decode(MovieRecord.self, from: movieData)
            self.movie = record.fields

            // get all info at the same time
            async let directorTask: () = loadDirector(movieID: id)
            async let actorsTask: () = loadActors(movieID: id)
            async let reviewsTask: () = loadReviews(movieID: id)
            
            _ = await (directorTask, actorsTask, reviewsTask)

        } catch {
            errorMessage = "Failed to load movie: \(error.localizedDescription)"
            print("Error loading movie: \(error)")
        }

        isLoading = false
    }

    
    private func loadDirector(movieID: String) async {
        do {
            // get a specific director
            let urlString = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movie_directors?filterByFormula=movie_id=\"\(movieID)\""
            let data = try await APIClient.fetch(URL(string: urlString)!)
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let records = json?["records"] as? [[String: Any]]
            let fields = records?.first?["fields"] as? [String: Any]
            let directorID = fields?["director_id"] as? String

            guard let directorID else { return }

            let directorURL = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/directors/\(directorID)")!
            let directorData = try await APIClient.fetch(directorURL)

            let directorJSON = try JSONSerialization.jsonObject(with: directorData) as? [String: Any]
            let directorFields = directorJSON?["fields"] as? [String: Any]

            let name = directorFields?["name"] as? String ?? ""
            let image = directorFields?["image"] as? String ?? ""

            self.director = Director(name: name, image: image)
        } catch {
            print("Director error:", error)
        }
    }
    
    private func loadActors(movieID: String) async {
        do {
            // get specific actors
            let urlString = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movie_actors?filterByFormula=movie_id=\"\(movieID)\""
            let data = try await APIClient.fetch(URL(string: urlString)!)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let records = json?["records"] as? [[String: Any]] ?? []

            let actorIDs: [String] = records.compactMap { $0["fields"] as? [String: Any] }
                                            .compactMap { $0["actor_id"] as? String }

            var tempActors: [Actor] = []

            for id in actorIDs {
                let actorURL = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/actors/\(id)")!
                let actorData = try await APIClient.fetch(actorURL)
                let actorJSON = try JSONSerialization.jsonObject(with: actorData) as? [String: Any]
                let fields = actorJSON?["fields"] as? [String: Any]
                let name = fields?["name"] as? String ?? ""
                let image = fields?["image"] as? String ?? ""

                tempActors.append(Actor(name: name, image: image))
            }
            self.actors = tempActors
        } catch {
            print("Actors error:", error)
        }
    }
    func loadReviews(movieID: String) async {
        isLoadingReviews = true
        print("🔄 Loading reviews for movie: \(movieID)")
        
        do {
            var allReviewRecords: [ReviewRecord] = []
            var offset: String? = nil
            
            repeat {
                var urlString = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/reviews?filterByFormula=movie_id=\"\(movieID)\""
                
                if let currentOffset = offset {
                    urlString += "&offset=\(currentOffset)"
                }
                
                guard let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                      let url = URL(string: encodedURL) else {
                    print("❌ Bad URL generation")
                    return
                }
                
                let data = try await APIClient.fetch(url)
                
                struct ReviewResponse: Codable {
                    let records: [ReviewRecord]
                    let offset: String?
                }
                
                let response = try JSONDecoder().decode(ReviewResponse.self, from: data)
                allReviewRecords.append(contentsOf: response.records)
                offset = response.offset
                
            } while offset != nil
            
            print("✅ Found \(allReviewRecords.count) raw records. Now fetching user details...")
            
            var movieReviews: [MovieReview] = []
            
            
            for record in allReviewRecords {
               
                guard let userID = record.fields.user_id, !userID.isEmpty else {
                    print("⚠️ Skipping review \(record.id) because it has no User ID.")
                    continue
                }
                
                if userID == "recXXXXXXXXXXXXXX" { continue }

                if let user = await fetchUser(userID: userID) {
                    let review = MovieReview(
                        id: record.id,
                        author: user.name,
                        authorImage: user.profile_image,
                        text: record.fields.review_text,
                        rating: record.fields.rate
                    )
                    movieReviews.append(review)
                }
            }
            
            
            await MainActor.run {
                self.reviews = movieReviews
            }
            
        } catch {
            print("❌ Reviews error:", error)
        }
        
        isLoadingReviews = false
    }
    
    private func fetchUser(userID: String) async -> User? {
            if userID == "TEMP_USER_ID" { return nil }
            
            do {
                let url = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/users/\(userID)")!
                let data = try await APIClient.fetch(url)
                
                let record = try JSONDecoder().decode(UserRecord.self, from: data)
                return record.fields
            } catch {
                return nil
            }
        }
    
    
    func addReview(movieID: String, reviewText: String, rating: Int) async {
            isLoading = true
            do {
                let url = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/reviews")!
                
                let currentUserID = UserSession.currentUserID
                
                let body: [String: Any] = [
                    "fields": [
                        "movie_id": movieID,
                        "user_id": currentUserID,
                        "review_text": reviewText.trimmingCharacters(in: .whitespacesAndNewlines),
                        "rate": rating
                    ]
                ]
                
                try await APIClient.post(url, body: body)
                print("✅ Review added for user: \(currentUserID)")
                await loadReviews(movieID: movieID)
                
            } catch {
                print("❌ Failed to add review: \(error)")
                errorMessage = "Failed to add review."
            }
            isLoading = false
        }

    func saveMovie(movieID: String) async {
            isLoading = true
            do {
                let url = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/saved_movies")!
                
                let currentUserID = UserSession.currentUserID
                
                let body: [String: Any] = [
                        "fields": [
                            "user_id": UserSession.currentUserID,
                            "movie_id": [movieID]
                        ],
                        "typecast": true
                    ]
                try await APIClient.post(url, body: body)
                print("Movie saved for user: \(currentUserID)")
                
            } catch {
                print("Failed to save movie: \(error)")
                errorMessage = "Failed to save movie."
            }
            isLoading = false
        }
}
