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
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadMovie(id: String) async {
        isLoading = true

        do {
            // 1. Load movie
            let movieURL = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movies/\(id)")!
            let movieData = try await fetch(movieURL)
            let record = try JSONDecoder().decode(MovieRecord.self, from: movieData)
            movie = record.fields

            // 2. Load director
            await loadDirector(movieID: id)

            // Load actors
            await loadActors(movieID: id)

        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func loadDirector(movieID: String) async {
        do {
            let urlString =
            "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movie_directors?filterByFormula=movie_id=\"\(movieID)\""

            let data = try await fetch(URL(string: urlString)!)
            
            // decode ONLY director_id
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let records = json?["records"] as? [[String: Any]]
            let fields = records?.first?["fields"] as? [String: Any]
            let directorID = fields?["director_id"] as? String

            guard let directorID else { return }

            // 3. Fetch director details
            let directorURL =
            URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/directors/\(directorID)")!

            let directorData = try await fetch(directorURL)

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
            
            let data = try await fetch(URL(string: urlString)!)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let records = json?["records"] as? [[String: Any]] ?? []

            // Get all actor IDs
            let actorIDs: [String] = records.compactMap { $0["fields"] as? [String: Any] }
                                              .compactMap { $0["actor_id"] as? String }

            var tempActors: [Actor] = []

            // Fetch each actor
            for id in actorIDs {
                let actorURL = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/actors/\(id)")!
                let actorData = try await fetch(actorURL)
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

    private func fetch(_ url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(APIKey.airtable)", forHTTPHeaderField: "Authorization")
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
