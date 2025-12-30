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

struct ReviewRecord: Codable, Identifiable {
    let id: String
    let fields: Review
}

struct Review: Codable {
    let rate: Int
    let review_text: String
    let movie_id: String
    let user_id: String
}


struct UsersResponse: Codable {
    let records: [UserRecord]
}

struct UserRecord: Codable {
    let id: String
    let fields: User
}


struct User: Codable {
    let name: String
    let email: String
    let password: String
    let profile_image: String
}

struct MovieReview: Identifiable {
    let id: String
    let author: String
    let authorImage: String
    let text: String
    let rating: Int
}


enum APIKey {
    static let airtable = Bundle.main
        .infoDictionary?["AIRTABLE_API_KEY"] as? String ?? ""
}
