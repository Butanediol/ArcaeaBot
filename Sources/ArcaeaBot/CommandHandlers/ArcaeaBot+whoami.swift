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

		var text: String
		if context.args.scanWord() == "debug" {
			text = String(data: try JSONEncoder().encode(user), encoding: .utf8) ?? Prompts.jsonEncodingError.rawValue
		} else {
			text = "Hello \(user.userInfo.displayName)."
		}

		context.respondAsync(text, replyToMessageId: context.message?.messageId)

		return true
	}

}