//
//  MovieDetailsViewModel.swift
//  Movieisme
//
//  Created by Suhaylah hawsawi on 06/07/1447 AH.
//

import SwiftUI
import Combine

@MainActor
class MovieDetailsViewModel: ObservableObject {
    @Published var movie: Movie?
    @Published var director: Director?
    @Published var actors: [Actor] = []
    @Published var reviews: [MovieReview] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadMovie(id: String) async {
        isLoading = true

        do {
            // 1. Load movie
            let movieURL = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movies/\(id)")!
            let movieData = try await APIClient.fetch(movieURL)
            let record = try JSONDecoder().decode(MovieRecord.self, from: movieData)
            movie = record.fields

            // 2. Load director
            await loadDirector(movieID: id)

            // Load actors
            await loadActors(movieID: id)
            
            await loadReviews(movieID: id)

        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func loadDirector(movieID: String) async {
        do {
            let urlString =
            "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movie_directors?filterByFormula=movie_id=\"\(movieID)\""

            let data = try await APIClient.fetch(URL(string: urlString)!)
            
            // decode ONLY director_id
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let records = json?["records"] as? [[String: Any]]
            let fields = records?.first?["fields"] as? [String: Any]
            let directorID = fields?["director_id"] as? String

            guard let directorID else { return }

            // 3. Fetch director details
            let directorURL =
            URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/directors/\(directorID)")!

            let directorData = try await APIClient.fetch(directorURL)

            let directorJSON =
                try JSONSerialization.jsonObject(with: directorData) as? [String: Any]
            let directorFields =
                directorJSON?["fields"] as? [String: Any]

            let name = directorFields?["name"] as? String ?? ""
            let image = directorFields?["image"] as? String ?? ""

            director = Director(name: name, image: image)

        } catch {
            print("Director error:", error)
        }
    }
    
    private func loadActors(movieID: String) async {
        do {
            let urlString =
            "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movie_actors?filterByFormula=movie_id=\"\(movieID)\""
            
            let data = try await APIClient.fetch(URL(string: urlString)!)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let records = json?["records"] as? [[String: Any]] ?? []

            // Get all actor IDs
            let actorIDs: [String] = records.compactMap { $0["fields"] as? [String: Any] }
                                              .compactMap { $0["actor_id"] as? String }

            var tempActors: [Actor] = []

            // Fetch each actor
            for id in actorIDs {
                let actorURL = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/actors/\(id)")!
                let actorData = try await APIClient.fetch(actorURL)
                let actorJSON = try JSONSerialization.jsonObject(with: actorData) as? [String: Any]
                let fields = actorJSON?["fields"] as? [String: Any]
                let name = fields?["name"] as? String ?? ""
                let image = fields?["image"] as? String ?? ""

                tempActors.append(Actor(name: name, image: image))
            }

            actors = tempActors

        } catch {
            print("Actors error:", error)
        }
    }

    private func loadReviews(movieID: String) async {
        do {
            let urlString =
            "https://api.airtable.com/v0/appsfcB6YESLj4NCN/reviews?filterByFormula=movie_id=\"\(movieID)\""

            let data = try await APIClient.fetch(URL(string: urlString)!)

            struct ReviewResponse: Codable {
                let records: [ReviewRecord]
            }

            let decoded = try JSONDecoder().decode(ReviewResponse.self, from: data)

            var tempReviews: [MovieReview] = []

            for record in decoded.records {
                let userURL =
                URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/users/\(record.fields.user_id)")!

                let userData = try await APIClient.fetch(userURL)
                let userRecord = try JSONDecoder().decode(UserRecord.self, from: userData)

                let review = MovieReview(
                    id: record.id,
                    author: userRecord.fields.name,
                    authorImage: userRecord.fields.profile_image,
                    text: record.fields.review_text,
                    rating: record.fields.rate
                )

                tempReviews.append(review)
            }

            reviews = tempReviews

        } catch {
            print("Reviews error:", error)
        }
    }

}
