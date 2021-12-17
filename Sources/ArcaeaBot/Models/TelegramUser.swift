import Foundation

struct TelegramUser: Codable {
	let telegramUserId: TelegramUserId
	let arcaeaFriendCode: ArcaeaFriendCode
	let userInfo: UserInfo
}

typealias TelegramUserId = Int64
typealias ArcaeaFriendCode = Int