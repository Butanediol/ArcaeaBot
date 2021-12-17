import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func best30(context: Context) throws -> Bool {

		guard let telegramUserId = context.fromId else {
			ArcaeaBot.logger.info("Get telegram user id failed.")
			return true
		}

		guard let user = userManager.getUser(telegramUserId: telegramUserId) else {
			context.respondSync("You have not binded yet. Try /bind .")
			return true
		}

		api.get(endpoint: .best(user.arcaeaFriendCode)) { (result: Result<Best30Response, Error>) in
			switch result {
				case .success(let b30response):
					context.respondSync(b30response.best30.map { play in
						return "\(play.songID) \(play.score)"
					}.joined(separator: "\n"))

				case .failure(let error):
					context.respondSync("\(error.localizedDescription)")
			}
		}

		return true
	}

}