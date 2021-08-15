import TelegramBotSDK

extension Context {
	func sendChatActionAsync(action: String) {
		guard let chatId = self.chatId else { return }
		self.bot.sendChatActionAsync(chatId: .chat(chatId), action: action)
	}
}