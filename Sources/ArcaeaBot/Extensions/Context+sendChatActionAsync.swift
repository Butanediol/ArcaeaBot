import TelegramBotSDK

extension Context {
	func sendChatActionAsync(action: String) {
		self.bot.sendChatActionAsync(chatId: .chat(self.chatId ?? 0), action: action)
	}
}