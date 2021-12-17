import Foundation

// MARK: - UserInfoResponse
struct UserInfoResponse: Codable {
    let userInfo: UserInfo

    enum CodingKeys: String, CodingKey {
        case userInfo = "data"
    }
}

// MARK: - UserInfo
struct UserInfo: Codable {
    let displayName: String
    let potential: Int
    let partner: Partner
    let lastPlayedSong: LastPlayedSong

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case potential, partner
        case lastPlayedSong = "last_played_song"
    }
}

// MARK: - LastPlayedSong
struct LastPlayedSong: Codable {
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

// MARK: - Partner
struct Partner: Codable {
    let partnerID: Int
    let isAwakened: Bool

    enum CodingKeys: String, CodingKey {
        case partnerID = "partner_id"
        case isAwakened = "is_awakened"
    }
}