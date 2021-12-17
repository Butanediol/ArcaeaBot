import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func whoami(context: Context) throws -> Bool {

		guard let telegramUserId = context.fromId else {
			ArcaeaBot.logger.info("Get telegram user id failed.")
			return true
		}

		guard let user = userManager.getUser(telegramUserId: telegramUserId) else {
			context.respondSync("You have not binded yet. Try /bind .")
			return true
		}

		context.respondSync("Hello \(user.userInfo.displayName).")

		return true
	}

}