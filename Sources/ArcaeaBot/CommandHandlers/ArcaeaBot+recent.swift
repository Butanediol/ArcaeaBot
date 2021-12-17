import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func recent(context: Context) throws -> Bool {

		guard let telegramUserId = context.fromId else {
			ArcaeaBot.logger.info("Get telegram user id failed.")
			return true
		}

		guard let user = userManager.getUser(telegramUserId: telegramUserId) else {
			context.respondSync("You have not binded yet. Try /bind .")
			return true
		}

		api.get(endpoint: .userInfo(user.arcaeaFriendCode)) { (result: Result<UserInfoResponse, Error>) in
			switch result {
				case .success(let userInfoResponse):
					let lastPlayedSong = userInfoResponse.userInfo.lastPlayedSong
					context.respondSync("\(lastPlayedSong.songID)\n\(lastPlayedSong.difficulty.abbr.uppercased())\n\(lastPlayedSong.score)")
				case .failure(let error):
					context.respondSync("Error: \(error.localizedDescription)")
			}
		}

		return true
	}

}