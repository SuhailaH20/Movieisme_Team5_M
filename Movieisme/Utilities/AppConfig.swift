import Foundation

enum APIKey {
    static let airtable = Bundle.main
        .infoDictionary?["AIRTABLE_API_KEY"] as? String ?? ""
}
