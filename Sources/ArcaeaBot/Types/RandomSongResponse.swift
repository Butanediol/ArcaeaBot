// MARK: - RandomSongResponse

struct RandomSongResponse: APIRequestResponsable {
    var status: Int
    var content: RandomSong
}

// MARK: - Content

struct RandomSong: Codable {
    let id: String
    let ratingClass: Difficulty

    enum CodingKeys: String, CodingKey {
        case id
        case ratingClass = "rating_class"
    }
}
