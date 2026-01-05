
import SwiftUI
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var savedMovies: [MovieRecord] = []
    @Published var isLoading = false
    
    let currentUserID = UserSession.currentUserID

    func loadSavedMovies() async {
        isLoading = true
        savedMovies = [] 
        print("Fetching saved movies...")

        do {
            let urlString = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/saved_movies?filterByFormula=user_id=\"\(currentUserID)\""
            
            guard let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: encodedURL) else { return }
            
            let data = try await APIClient.fetch(url)
            
            struct SavedResponse: Codable {
                let records: [SavedMovieRecord]
            }
            
            let response = try JSONDecoder().decode(SavedResponse.self, from: data)
            print("✅ Found \(response.records.count) saved records. Fetching details...")

            for record in response.records {
                if let movieID = record.fields.movie_id?.first {
                    await fetchSingleMovie(movieID: movieID)
                }
            }
            
        } catch {
            print("❌ Error fetching saved movies:", error)
        }
        
        isLoading = false
    }
    
    private func fetchSingleMovie(movieID: String) async {
        let urlString = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/movies/\(movieID)"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let data = try await APIClient.fetch(url)
            let movie = try JSONDecoder().decode(MovieRecord.self, from: data)
            self.savedMovies.append(movie)
        } catch {
            print("⚠️ Could not load details for movie \(movieID)")
        }
    }
}
