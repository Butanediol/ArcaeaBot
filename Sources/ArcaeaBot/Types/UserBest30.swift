import Foundation
import SwiftLMDB

// MARK: - UserBest30

struct UserBest30: APIRequestResponsable {
    var status: Int
    var content: UserBest30Content
}

// MARK: - Content

struct UserBest30Content: Codable {
    let best30Avg, recent10Avg: Double
    let best30List: [UserPlay]
    let best30Overflow: [UserPlay]?

    enum CodingKeys: String, CodingKey {
        case best30Avg = "best30_avg"
        case recent10Avg = "recent10_avg"
        case best30List = "best30_list"
        case best30Overflow = "best30_overflow"
    }
}

extension UserBest30: DataConvertible {
    public init?(data: Data) {
        self = try! JSONDecoder().decode(UserBest30.self, from: data)
    }

    public var asData: Data {
        return try! JSONEncoder().encode(self)
    }
}
