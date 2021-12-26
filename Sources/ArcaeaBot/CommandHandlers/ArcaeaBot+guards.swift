import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func guardUser(context: Context) -> Bool {
		context.respondAsync("You have not bind yet. Try send bind in private message.")
		return true
	}

	func guardBot(context: Context) -> Bool {
		context.respondAsync("Please send commands with your personal account.")
		return true
	}

}