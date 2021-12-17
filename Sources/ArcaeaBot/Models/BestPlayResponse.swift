import Foundation

// MARK: - BestPlayResponse
struct BestPlayResponse: Codable {
    let bestPlay: BestPlay

    enum CodingKeys: String, CodingKey {
        case bestPlay = "data"
    }
}

// MARK: - DataClass
struct BestPlay: Codable {
    let songID: String
    let difficulty: Difficulty
    let score, shinyPureCount, pureCount: Int
    let farCount, lostCount, recollectionRate, timePlayed: Int
    let gaugeType: Int

    enum CodingKeys: String, CodingKey {
        case songID = "song_id"
        case difficulty, score
        case shinyPureCount = "shiny_pure_count"
        case pureCount = "pure_count"
        case farCount = "far_count"
        case lostCount = "lost_count"
        case recollectionRate = "recollection_rate"
        case timePlayed = "time_played"
        case gaugeType = "gauge_type"
    }
}