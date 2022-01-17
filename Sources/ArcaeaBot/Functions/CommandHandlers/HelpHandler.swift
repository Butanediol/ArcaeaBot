import Foundation
import TelegramBotSDK

func helpHandler(context: Context) -> Bool {

	context.sendChatActionAsync(action: "typing")
	let help = """
	/my <Song>
	/recent
	/best30
	/me
	/bind <ArcID/ArcName>

	We built another bot using the official API provided by lowiro. Please check @SakuraDoubleStarBot
	"""

	context.respondPrivatelyAsync(help, groupText: "帮助信息请查看私聊。")

	return true
}