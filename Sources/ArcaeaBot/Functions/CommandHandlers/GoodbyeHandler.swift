import Foundation
import TelegramBotSDK

func goodbyeHandler(context: Context) -> Bool {
    guard let message = context.message, let leftUser = message.leftChatMember else { return true }

    if let info = getUserInfoFromDatabase(tgUserId: leftUser.id) {
        context.sendThenDeleteMessageAsync(text: "再见\(info.rank)\(info.content.name)。")
    } else {
        context.sendThenDeleteMessageAsync(text: "再见，\(leftUser.firstName + (leftUser.lastName ?? ""))。")
    }

    return true
}
