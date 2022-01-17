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

	/multiplay 
	/multiplay <Song>
	/multiplay <Floor> <Ceiling>
	/multiplay <Floor> +
	/multiplay <Ceiling> -

	/begin
	/finish
	/cancel

	We built another bot using the official API provided by lowiro. Please check @SakuraDoubleStarBot
	"""

	context.respondPrivatelyAsync(help, groupText: "帮助信息请查看私聊。")

	return true
}