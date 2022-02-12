import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func bind(context: Context) throws -> Bool {

		if context.message?.from?.isBot == true || context.message?.from?.id == 136817688 { // Channel bot
			return guardBot(context: context)
		}

		guard let arg = context.args.scanWords().first, let friendCode = Int(arg) else {
			context.respondAsync("Usage:\n\tbind <Friend Code>", replyToMessageId: context.message?.messageId)
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
			context.sendChatActionAsync(action: "typing")
			context.respondAsync("You have already binded to \(existedUser.userInfo.displayName)(\(existedUser.arcaeaFriendCode))", replyToMessageId: context.message?.messageId)
		} else {
			ArcaeaBot.logger.info("No existed user, binding.")

			api.get(endpoint: .userInfo(friendCode)) { (result: Result<UserInfoResponse, Error>) in
				context.sendChatActionAsync(action: "typing")
				switch result {
					case .success(let userInfoResponse):
						self.userManager.addUser(telegramUserId: telegramUserId, arcaeaFriendCode: friendCode, userInfo: userInfoResponse.userInfo)
						context.respondAsync("Welcome \(userInfoResponse.userInfo.displayName)!", replyToMessageId: context.message?.messageId)
					case .failure(let error):
						ArcaeaBot.logger.error("\(error.localizedDescription)")
				}
				ArcaeaBot.logger.info("Bind ended.")
			}
		}
		
		return true
	}

}

