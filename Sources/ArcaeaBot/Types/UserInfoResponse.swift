import Foundation
import SwiftLMDB

// MARK: - UserInfoResponse

struct UserInfoResponse: APIRequestResponsable {
    var status: Int
    var content: UserInfoResponseContent
}

extension UserInfoResponse: DataConvertible {
    public init?(data: Data) {
        // - TODO: Something weird happen
        do {
            self = try JSONDecoder().decode(UserInfoResponse.self, from: data)
        } catch {
            self = UserInfoResponse(status: -1, content: .empty)
        }
    }

    public var asData: Data {
        return try! JSONEncoder().encode(self)
    }
}

struct UserInfoResponseContent: Codable {
    var accountInfo: AccountInfo
    var recentScore: [Score]

    enum CodingKeys: String, CodingKey {
        case accountInfo = "account_info"
        case recentScore = "recent_score"
    }

    static let empty = UserInfoResponseContent(accountInfo: .empty, recentScore: [])
}

struct AccountInfo: Codable {
    var code: String
    var name: String
    var userId: UserId
    var isMutual: Bool
    var isCharUncappedOverride: Bool
    var isCharUncapped: Bool
    var isSkillSealed: Bool
    var rating: Int
    var joinDate: Date
    var character: Int

    enum CodingKeys: String, CodingKey {
        case code, name, rating, character
        case userId = "user_id"
        case isMutual = "is_mutual"
        case isCharUncappedOverride = "is_char_uncapped_override"
        case isCharUncapped = "is_char_uncapped"
        case isSkillSealed = "is_skill_sealed"
        case joinDate = "join_date"
    }

    typealias UserId = Int

    static let empty = AccountInfo(code: "", name: "", userId: -1, isMutual: false, isCharUncappedOverride: false, isCharUncapped: false, isSkillSealed: false, rating: -1, joinDate: Date(), character: -1)

}

struct Score: Codable {
    // let userID: Int
    let score, health: Int
    let rating: Double
    let songID: String
    let modifier: Int
    let difficulty: Difficulty
    let clearType, bestClearType: Int
    let timePlayed, nearCount, missCount, perfectCount: Int
    let shinyPerfectCount: Int

    enum CodingKeys: String, CodingKey {
        // case userID = "user_id"
        case score, health, rating
        case songID = "song_id"
        case modifier, difficulty
        case clearType = "clear_type"
        case bestClearType = "best_clear_type"
        case timePlayed = "time_played"
        case nearCount = "near_count"
        case missCount = "miss_count"
        case perfectCount = "perfect_count"
        case shinyPerfectCount = "shiny_perfect_count"
    }

    static let empty = Score(score: -1, health: -1, rating: -1, songID: "", modifier: -1, difficulty: .past, clearType: -1, bestClearType: -1, timePlayed: -1, nearCount: -1, missCount: -1, perfectCount: -1, shinyPerfectCount: -1)
}

extension AccountInfo {
    var rank: String {
        if rating >= 1250 {
            return "，双星人"
        } else if rating >= 1200 {
            return "，摘星人"
        } else if rating >= 1100 {
            return "，红框人"
        } else if rating >= 1000 {
            return "，紫框人"
        } else {
            return ""
        }
    }
}