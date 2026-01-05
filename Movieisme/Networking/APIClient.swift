

import Foundation

struct APIClient {

    // GET Requests
    static func fetch(_ url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.setValue(
            "Bearer \(APIKey.airtable)",
            forHTTPHeaderField: "Authorization"
        )

        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    // POST Requests (saved movies & add reviews)
    static func post(_ url: URL, body: [String: Any]) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(APIKey.airtable)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8),"😀")
        
        if let httpResponse = response as? HTTPURLResponse {
            print("POST Status Code: \(httpResponse.statusCode)")
        }
    }
}
