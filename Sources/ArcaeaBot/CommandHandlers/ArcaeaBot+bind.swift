import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func bind(context: Context) throws -> Bool {
		guard let arg = context.args.scanWords().first, let friendCode = Int(arg) else {
			context.respondAsync("Usage:\n\t/bind <Friend Code>")
			ArcaeaBot.logger.debug("Binding \(context.fromId ?? -1) Failed: No valid argument.")
			return true
		}

		guard let telegramUserId = context.fromId else {
			ArcaeaBot.logger.info("Get telegram user id failed.")
			return true
		}

		ArcaeaBot.logger.info("Binding \(telegramUserId) <-> \(String(format: "%09d", friendCode))")
		
		if let existedUser =  userManager.getUser(telegramUserId: telegramUserId) {
			ArcaeaBot.logger.info("Bind user failed: rebinding.")
			context.respondAsync("You have already binded to \(existedUser.userInfo.displayName)(\(existedUser.arcaeaFriendCode))")
		} else {
			ArcaeaBot.logger.info("No existed user, binding.")

			api.get(endpoint: .userInfo(friendCode)) { (result: Result<UserInfoResponse, Error>) in
				switch result {
					case .success(let userInfoResponse):
						self.userManager.addUser(telegramUserId: telegramUserId, arcaeaFriendCode: friendCode, userInfo: userInfoResponse.userInfo)
						context.respondAsync("Welcome \(userInfoResponse.userInfo.displayName)!")
					case .failure(let error):
						ArcaeaBot.logger.error("\(error.localizedDescription)")
				}
				ArcaeaBot.logger.info("Bind ended.")
			}
		}
		
		return true
	}

}

extension Context {
	func respondAsync<T: Localizable>(_ text: T,
                            parseMode: ParseMode? = nil,
                            disableWebPagePreview: Bool? = nil,
                            disableNotification: Bool? = nil,
                            replyToMessageId: Int? = nil,
                            replyMarkup: ReplyMarkup? = nil,
                            _ parameters: [String: Encodable?] = [:]) -> Message? {

		return self.respondAsync(text.localizedString, parseMode: parseMode, disableWebPagePreview: disableWebPagePreview, disableNotification: disableNotification, replyToMessageId: replyToMessageId, replyMarkup: replyMarkup, parameters)
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
