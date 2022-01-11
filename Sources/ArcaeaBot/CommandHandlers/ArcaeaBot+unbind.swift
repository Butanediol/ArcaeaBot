import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func unbind(context: Context) throws -> Bool {

		guard let telegramUserId = context.fromId else {
			ArcaeaBot.logger.info("Get telegram user id failed.")
			return true
		}

		guard let user = userManager.getUser(telegramUserId: telegramUserId) else {
			return guardUser(context: context)
		}

		userManager.deleteUser(telegramUserId: telegramUserId)

		context.sendChatActionAsync(action: "typing")
		context.respondAsync("Goodbye \(user.userInfo.displayName).")

		return true
	}

}