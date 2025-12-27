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
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadMovie(id: String) async {
        isLoading = true
        errorMessage = nil

        let urlString = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movies/\(id)"
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }
        print("API KEY:", APIKey.airtable)
        var request = URLRequest(url: url)
        request.setValue("Bearer \(APIKey.airtable)", forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let record = try JSONDecoder().decode(MovieRecord.self, from: data)
            self.movie = record.fields
        } catch {
            errorMessage = "Failed to load movie: \(error.localizedDescription)"
            print(errorMessage!)
        }

        isLoading = false
    }
}
