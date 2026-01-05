
import Foundation

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
