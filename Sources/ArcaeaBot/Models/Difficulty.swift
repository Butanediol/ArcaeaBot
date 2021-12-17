import Foundation

// MARK: Difficulty
enum Difficulty: Int, Codable {
    case past = 1, present, future, beyond

    var abbr: String {
        switch self {
            case .past: return "pst"
            case .present: return "prs"
            case .future: return "ftr"
            case .beyond: return "byd"
        }
    }
}