
import Foundation

struct ReviewRecord: Codable, Identifiable {
    let id: String
    let fields: Review
}

struct Review: Codable {
    let rate: Int
    let review_text: String
    let movie_id: String
    let user_id: String?
}

struct MovieReview: Identifiable {
    let id: String
    let author: String
    let authorImage: String
    let text: String
    let rating: Int
}
