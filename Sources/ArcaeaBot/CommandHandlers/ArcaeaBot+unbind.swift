import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func unbind(context: Context) throws -> Bool {

		guard let telegramUserId = context.fromId else {
			ArcaeaBot.logger.info("Get telegram user id failed.")
			return true
		}

		guard let user = userManager.getUser(telegramUserId: telegramUserId) else {
			context.respondAsync("You have not binded yet. Try /bind .")
			return true
		}

		userManager.deleteUser(telegramUserId: telegramUserId)

		context.respondAsync("Goodbye \(user.userInfo.displayName).")

		return true
	}

}