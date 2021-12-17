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
    let lastPlayedSong: Play

    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case potential, partner
        case lastPlayedSong = "last_played_song"
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