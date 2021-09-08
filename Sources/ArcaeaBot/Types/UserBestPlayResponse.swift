import Foundation

// MARK: - UserBest

struct UserBestPlayResponse: APIRequestResponsable {
    var status: Int
    var content: UserPlay
}

typealias PlayScore = Int

// MARK: - UserPlay

struct UserPlay: Codable {
    let songID: String
    let difficulty: Difficulty
    let score: PlayScore
    let shinyPerfectCount, perfectCount: Int
    let nearCount, missCount, health, modifier: Int
    let timePlayed, bestClearType, clearType: Int
    let character: Int?
    let isSkillSealed: Bool?
    let isCharUncapped: Bool?
    let rating: Double

    enum CodingKeys: String, CodingKey {
        case songID = "song_id"
        case difficulty, score
        case shinyPerfectCount = "shiny_perfect_count"
        case perfectCount = "perfect_count"
        case nearCount = "near_count"
        case missCount = "miss_count"
        case health, modifier
        case timePlayed = "time_played"
        case bestClearType = "best_clear_type"
        case clearType = "clear_type"
        case character
        case isSkillSealed = "is_skill_sealed"
        case isCharUncapped = "is_char_uncapped"
        case rating
    }

    static let emptyPlay = UserPlay(songID: "", difficulty: .future, score: 0, shinyPerfectCount: 0, perfectCount: 0, nearCount: 0, missCount: 0, health: 0, modifier: 0, timePlayed: 0, bestClearType: 0, clearType: 0, character: 0, isSkillSealed: false, isCharUncapped: false, rating: 0.0)
}
