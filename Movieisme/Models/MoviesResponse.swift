//
//  MoviesResponse.swift
//  Movieisme
//
//  Created by Suhaylah hawsawi on 06/07/1447 AH.
//


import Foundation

struct MovieRecord: Codable, Identifiable {
    let id: String
    let fields: Movie
}

// MARK: - Movie Model
struct Movie: Codable {
    let name: String
    let poster: String
    let story: String
    let runtime: String
    let genre: [String]
    let rating: String
    let IMDb_rating: Double
    let language: [String]
}

struct Director: Codable {
    let name: String
    let image: String
}

struct Actor: Codable, Identifiable {
    var id = UUID()
    let name: String
    let image: String
}

enum APIKey {
    static let airtable = Bundle.main
        .infoDictionary?["AIRTABLE_API_KEY"] as? String ?? ""
}
