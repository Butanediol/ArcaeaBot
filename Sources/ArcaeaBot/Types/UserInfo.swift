import SwiftLMDB
import Foundation

// MARK: - UserInfo
struct UserInfo: Codable {
    let status: Int
    let content: UserInfoContent
}

extension UserInfo: DataConvertible {
    public init?(data: Data) {
        // - TODO: Something weird happen
        do {
            self = try JSONDecoder().decode(UserInfo.self, from: data)
        } catch {
            self = UserInfo(status: -1, content: .emptyUserInfoContent)
        }
    }

    public var asData: Data {
        return try! JSONEncoder().encode(self)
    }
}

extension UserInfo {
    var rank: String {
        if self.content.rating >= 1250 {
            return "，双星人"
        } else if self.content.rating >= 1200 {
            return "，摘星人"
        } else if self.content.rating >= 1100 {
            return "，红框人"
        } else if self.content.rating >= 1000 {
            return "，紫框人"
        } else {
            return ""
        }
    }
}

// MARK: - UserInfoContent
struct UserInfoContent: Codable {
    let userID: Int
    let name: String
    let recentScore: [UserPlay]
    let character: Int
    let joinDate: Int
    let rating: Int
    let code: String
    let isSkillSealed, isCharUncapped, isCharUncappedOverride, isMutual: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name
        case recentScore = "recent_score"
        case character
        case joinDate = "join_date"
        case rating
        case isSkillSealed = "is_skill_sealed"
        case isCharUncapped = "is_char_uncapped"
        case isCharUncappedOverride = "is_char_uncapped_override"
        case isMutual = "is_mutual"
        case code
    }

    static let emptyUserInfoContent = UserInfoContent(userID: 0, name: "Empty User", recentScore: [], character: 0, joinDate: 0, rating: 0, code: "0", isSkillSealed: false, isCharUncapped: false, isCharUncappedOverride: false, isMutual: false)
}