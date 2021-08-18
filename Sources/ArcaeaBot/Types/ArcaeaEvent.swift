import Foundation

struct ArcaeaEvent: Codable {
    var map: String
    var levels: Int
    var steps: Int
    var prize: ArcaeaEventPrize
    var from: Date
    var to: Date
}

struct ArcaeaEventPrize: Codable {
    var partner: [String]?
    var fragment: Int?
    var etherDrop: Int?
}

extension ArcaeaEventPrize {
    var flatArray: [String] {
        var arr: [String] = []
        if let partner = partner {
            arr += partner
        }

        if let fragment = fragment {
            arr.append("残片\\*\(fragment)")
        }

        if let etherDrop = etherDrop {
            arr.append("以太之滴\\*\(etherDrop)")
        }
        return arr
    }
}