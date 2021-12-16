import Foundation

struct TelegramUser: Codable {
	let telegramUserId: TelegramUserId
	let arcaeaFriendCode: ArcaeaFriendCode
}

typealias TelegramUserId = Int64
typealias ArcaeaFriendCode = Int

actor UserManager {
	private let url: URL

	init(path: String) {
		self.url = URL(fileURLWithPath: path)
	}

	func getAllUser() -> [TelegramUser] {
		guard let data = try? Data(contentsOf: url), let users = try? JSONDecoder().decode([TelegramUser].self, from: data) else {
			print("Error: Failed to get users.")
			return []
		}
		return users
	}

	func saveUsers(_ users: [TelegramUser]) {
		do {
			let data = try JSONEncoder().encode(users)
			let content = String(data: data, encoding: .utf8)!
			try content.write(to: url, atomically: true, encoding: .utf8)
		} catch {
			print("Error: Failed to save users.")
		}
	}

	func addUser(telegramUserId: TelegramUserId, arcaeaFriendCode: ArcaeaFriendCode) -> TelegramUser? {
		var users = getAllUser()
		
		if let existedUser = getUser(telegramUserId: telegramUserId) { return existedUser }

		users.append(TelegramUser(telegramUserId: telegramUserId, arcaeaFriendCode: arcaeaFriendCode))
		saveUsers(users)
		return nil
	}

	func deleteUser(telegramUserId: TelegramUserId) {
		var users = getAllUser()
		users.removeAll(where: { $0.telegramUserId == telegramUserId })
		saveUsers(users)
	}

	func getUser(telegramUserId: TelegramUserId) -> TelegramUser? {
		return getAllUser().filter {
			$0.telegramUserId == telegramUserId
		}.first
	}
}