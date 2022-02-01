import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func guardUser(context: Context) -> Bool {
		context.respondAsync(Prompts.notBind.rawValue)
		return true
	}

	func guardBot(context: Context) -> Bool {
		context.respondAsync(Prompts.anonymousUser.rawValue)
		return true
	}

}