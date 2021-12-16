import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func bind(context: Context) throws -> Bool {
		guard let arg = context.args.scanWords().first, let friendCode = Int(arg) else {
			context.respondSync("Usage:\n\t/bind <Friend Code>")
			logger.debug("Binding \(context.fromId ?? -1) Failed: No valid argument.")
			return true
		}

		guard let telegramUserId = context.fromId else {
			logger.info("Get telegram user id failed.")
			return true
		}

		logger.info("Binding \(telegramUserId) <-> \(String(format: "%09d", friendCode))")
		Task {
			await userManager.addUser(telegramUserId: telegramUserId, arcaeaFriendCode: friendCode)
		}


		return true
	}

}

extension Context {
	func respondSync<T: Localizable>(_ text: T,
                            parseMode: ParseMode? = nil,
                            disableWebPagePreview: Bool? = nil,
                            disableNotification: Bool? = nil,
                            replyToMessageId: Int? = nil,
                            replyMarkup: ReplyMarkup? = nil,
                            _ parameters: [String: Encodable?] = [:]) -> Message? {

		return self.respondSync(text.localizedString, parseMode: parseMode, disableWebPagePreview: disableWebPagePreview, disableNotification: disableNotification, replyToMessageId: replyToMessageId, replyMarkup: replyMarkup, parameters)
	}
}

struct Localizer {
	static let shared = Localizer()

	func localize(_ text: String) -> String {
		// TODO: Localizer
		return text
	}
}

extension String: Localizable {
    var localizedString: String {
        return Localizer.shared.localize(self)
    }
}
