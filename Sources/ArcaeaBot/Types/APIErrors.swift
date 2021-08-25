import Foundation

struct APIError: Codable, Error {
	let status: Int
	let message: String
	var errorMessage: String {
		 if let errorMessage = APIError.errorMessageMap[message.lowercased()] {
		 	return errorMessage
		 } else {
		 	return message.capitalized
		 }
	}

	static private let errorMessageMap: [String: String] = [
		"invalid username or usercode": "无效的用户名或 ID",
		"invalid usercode": "无效的 ID",
		"invalid recent number": "Invalid recent number",
		"not played yet": "你还没有玩过该谱面",
		"unknown error occurred": "未知错误，请重试",
		"foundation network error": "网络错误，请重试",
		"decoding error occurred": "解码错误，请重试",
		"user not found": "没有找到该用户，请检查后重试",
	]
}

extension APIError {
	// Some classic errors
	static let unknownError = APIError(status: -233, message: "unknown error occurred")
	static let networkError = APIError(status: -1000, message: "foundation network error")
	static let decodingError = APIError(status: -1001, message: "decoding error occurred")
}