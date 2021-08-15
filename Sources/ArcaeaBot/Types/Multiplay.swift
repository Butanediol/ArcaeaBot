import Foundation
import SwiftLMDB

struct Multiplay: Codable {
    let started: Bool
    let song: SongId
    let players: [TgUserId]
    var result: [TgUserId: Int] = [:]
}

extension Multiplay: DataConvertible {
	public init?(data: Data) {
        self = try! JSONDecoder().decode(Multiplay.self, from: data)
    }

    public var asData: Data {
        return try! JSONEncoder().encode(self)
    }
}