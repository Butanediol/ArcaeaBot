// MARK: - RandomSong
struct RandomSong: Codable {
    let status: Int
    let content: RandomSongContent
}

// MARK: - Content
struct RandomSongContent: Codable {
    let id: String
    let ratingClass: Int

    enum CodingKeys: String, CodingKey {
        case id
        case ratingClass = "rating_class"
    }
}