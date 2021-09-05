import Foundation
import TelegramBotSDK

func deleteMessageAfter(deadline: DispatchTime, context: Context, messageId: Int?) {
    guard let chatId = context.chatId, let messageId = messageId else { return }
    DispatchQueue.global().asyncAfter(deadline: deadline) {
        bot.deleteMessageAsync(chatId: .chat(chatId), messageId: messageId)
    }
}

extension Context {
    func sendThenDeleteMessageAsync(after dispatchTime: DispatchTime = .now() + 120, text: String, parseMode: ParseMode? = nil, disableWebPagePreview: Bool? = nil, disableNotification: Bool? = nil, replyToMessageId: Int? = nil, replyMarkup: ReplyMarkup? = nil, parameters: [String: Encodable?] = [:], queue: DispatchQueue = .main, completion _: TelegramBot.SendMessageCompletion? = nil) {
        respondAsync(text, parseMode: parseMode, disableWebPagePreview: disableWebPagePreview, disableNotification: disableNotification, replyToMessageId: replyToMessageId, replyMarkup: replyMarkup, parameters, queue: queue) { message, _ in
            deleteMessageAfter(deadline: dispatchTime, context: self, messageId: message?.messageId)
        }
    }
}
