enum Difficulty: Int, Codable {
	case past = 0, present, future, beyond
}

extension Difficulty {
	var name: String {
		switch self {
			case .past:
			return "past"
			case .present:
			return "present"
			case .future:
			return "future"
			case .beyond:
			return "beyond"
		}
	}

	var abbr: String {
		switch self {
			case .past:
			return "pst"
			case .present:
			return "prs"
			case .future:
			return "ftr"
			case .beyond:
			return "byd"
		}
	}
}