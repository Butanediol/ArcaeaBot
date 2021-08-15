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
	"""

	context.respondAsync(help, replyToMessageId: context.message?.messageId)

	return true
}