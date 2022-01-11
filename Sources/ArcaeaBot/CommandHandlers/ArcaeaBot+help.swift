import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func help(context: Context) throws -> Bool {

		let helpText = """
		Usage:
		bind: This command only works in private chat, no slash required.
		/recent: No parameter needed.
		/my: <SongName/SongID/SongAlias/FuzzySearchText> [Diffifulty]
		Diffifulty is optional, which can be "past/present/future/beyond" or "pst/prs/ftr/byd", default is future.
		/best30: No parameter needed.
		/whoami: No parameter needed.
		/dice: <Diffifulty> [Song Pack]
		"""

		context.sendChatActionAsync(action: "typing")
		context.respondPrivatelySync(helpText, groupText: "Help menu was sent privately.")

		return true
	}

}