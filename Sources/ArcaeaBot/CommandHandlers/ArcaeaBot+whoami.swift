import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func whoami(context: Context) throws -> Bool {

		guard let telegramUserId = context.fromId else {
			ArcaeaBot.logger.info("Get telegram user id failed.")
			return true
		}

		guard let user = userManager.getUser(telegramUserId: telegramUserId) else {
			context.respondAsync("You have not bind yet. Try send bind in private message.")
			return true
		}

		context.respondAsync("Hello \(user.userInfo.displayName).")

		return true
	}

}