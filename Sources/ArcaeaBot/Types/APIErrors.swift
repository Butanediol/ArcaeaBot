import Foundation

struct APIError: Codable, Error {
	let status: Int
	let message: String
}

extension APIError {
	static let errorMessageMap: [String: String] = [
		"invalid username or usercode": "无效的用户名或 ID",
		"invalid usercode": "无效的 ID",
		"invalid recent number": "Invalid recent number",
		"unknown error occurred": "未知错误",
	]

	static let unknownError = APIError(status: -233, message: "unknown error occurred")
	static let networkError = APIError(status: -1000, message: "foundation network error")
	static let decodingError = APIError(status: -1001, message: "decoding error occurred")
}