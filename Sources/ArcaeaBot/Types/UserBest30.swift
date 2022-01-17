import Foundation
import SwiftLMDB

// MARK: - UserBest30

struct UserBest30Response: APIRequestResponsable {
    var status: Int
    var content: UserBest30ResponseContent
}

// MARK: - Content

struct UserBest30ResponseContent: Codable {
    let best30Avg, recent10Avg: Double
    let accountInfo: AccountInfo
    let best30List: [Score]
    let best30Overflow: [Score]?
    let best30Songinfo: [SongInfoResponseContent]?
    let best30OverflowSonginfo: [SongInfoResponseContent]?

    enum CodingKeys: String, CodingKey {
        case best30Avg = "best30_avg"
        case recent10Avg = "recent10_avg"
        case best30List = "best30_list"
        case best30Overflow = "best30_overflow"
        case accountInfo = "account_info"
        case best30Songinfo = "best30_songinfo"
        case best30OverflowSonginfo = "best30_overflow_songinfo"
    }
}

extension UserBest30Response: DataConvertible {
    public init?(data: Data) {
        self = try! JSONDecoder().decode(UserBest30Response.self, from: data)
    }

    public var asData: Data {
        return try! JSONEncoder().encode(self)
    }
}
