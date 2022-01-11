import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func whoami(context: Context) throws -> Bool {

		guard let telegramUserId = context.fromId else {
			ArcaeaBot.logger.info("Get telegram user id failed.")
			return true
		}

		guard let user = userManager.getUser(telegramUserId: telegramUserId) else {
			return guardUser(context: context)
		}

		context.sendChatActionAsync(action: "typing")
		context.respondAsync("Hello \(user.userInfo.displayName).", replyToMessageId: context.message?.messageId)

		return true
	}

}