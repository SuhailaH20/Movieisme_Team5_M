//
//  APIClient.swift
//  Movieisme
//
//  Created by Suhaylah hawsawi on 09/07/1447 AH.
//

import Foundation

struct APIClient {

    static func fetch(_ url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.setValue(
            "Bearer \(APIKey.airtable)",
            forHTTPHeaderField: "Authorization"
        )

        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
