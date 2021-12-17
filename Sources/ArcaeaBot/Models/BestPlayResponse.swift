import Foundation

// MARK: - BestPlayResponse
struct BestPlayResponse: Codable {
    let bestPlay: Play

    enum CodingKeys: String, CodingKey {
        case bestPlay = "data"
    }
}