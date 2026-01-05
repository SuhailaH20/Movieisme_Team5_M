

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

struct MovieResponseWrapper: Codable {
    let records: [MovieRecord]
}
