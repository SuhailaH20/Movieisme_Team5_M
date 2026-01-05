//
//  ReviewAPI.swift
//  Movieisme
//

import Foundation

struct ReviewAPI {
    
    static func addReview(movieID: String, userID: String, reviewText: String, rating: Int) async throws {
        let urlString = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/reviews"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(APIKey.airtable)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "fields": [
                "movie_id": movieID,
                "user_id": userID,
                "review_text": reviewText,
                "rate": rating
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}


