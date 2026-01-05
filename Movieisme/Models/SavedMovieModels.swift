

struct SavedMoviesResponse: Codable {
    let records: [SavedMovieRecord]
}

struct SavedMovieRecord: Codable {
    let id: String
    let fields: SavedMovieFields
}

struct SavedMovieFields: Codable {
    let movie_id: [String]?
    let user_id: String?
}
