import Foundation

// MARK: - Best30Response
struct Best30Response: Codable {
    let best30: [BestPlay]

    enum CodingKeys: String, CodingKey {
        case best30 = "data"
    }
}