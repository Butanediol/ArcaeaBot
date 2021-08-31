import Foundation
import TelegramBotSDK

func requestFailureHandler(context: Context, error: APIError) {
    /* Send error message and delete after 30 seconds */
    context.sendThenDeleteMessageAsync(after: .now() + 30, text: error.errorMessage, replyToMessageId: context.message?.messageId)
}
