import Foundation
import TelegramBotSDK

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
