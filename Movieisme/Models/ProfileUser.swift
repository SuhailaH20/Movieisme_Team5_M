
import Foundation

struct ProfileUser {
    var firstName: String
    var lastName: String
    var email: String
    var imageName: String

    var fullName: String { "\(firstName) \(lastName)" }
}


