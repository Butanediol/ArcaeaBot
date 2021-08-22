import Foundation
import TelegramBotSDK

func requestFailureHandler(context: Context, error: APIError) {
	/* Send error message and delete after 30 seconds */
	guard let chatId = context.chatId else { return }
	context.respondAsync(error.message.capitalized, replyToMessageId: context.message?.messageId) { message, _ in
		if let message = message {
			deleteMessageAfter(
				deadline: .now() + 30, 
				bot: context.bot, 
				chatId: .chat(chatId), 
				messageId: message.messageId)
		}
	}
}

func deleteMessageAfter(deadline: DispatchTime, bot: TelegramBot, chatId: ChatId, messageId: Int) {
	DispatchQueue.global().asyncAfter(deadline: deadline) {
		bot.deleteMessageAsync(chatId: chatId, messageId: messageId)
	}
}