
import Foundation

struct Director: Codable {
    let name: String
    let image: String
}

struct Actor: Codable, Identifiable {
    var id = UUID()
    let name: String
    let image: String
}
