//
//  MoviesCenterViewModel.swift
//  Movieisme
//
//  Created by Dana on 12/07/1447 AH.
//

import Foundation
import Combine

@MainActor
class MoviesCenterViewModel: ObservableObject {
    @Published var movies: [MovieRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadMovies() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let url = URL(string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movies")!
            
            let data = try await APIClient.fetch(url)
            
            // Uses the wrapper now located in Movie.swift
            let response = try JSONDecoder().decode(MovieResponseWrapper.self, from: data)
            self.movies = response.records
            
        } catch {
            errorMessage = "Failed to load movies: \(error.localizedDescription)"
            print("Error fetching movies: \(error)")
        }
        
        isLoading = false
    }
}
