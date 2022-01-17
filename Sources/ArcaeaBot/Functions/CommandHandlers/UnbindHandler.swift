import Foundation
import TelegramBotSDK

func unbindHandler(context: Context) -> Bool {
    // /unbind [ArcName]
    context.sendChatActionAsync(action: "typing")

    if let arg = context.args.scanWord() {
        // With username provided
        for (id, info) in getAllUserInfo() {
            if info.content.accountInfo.name == arg {
                deleteUserInfoFromDatabase(tgUserId: id)
                context.respondAsync("再见，\(info.content.accountInfo.name)！", replyToMessageId: context.message?.messageId)
                return true
            }
        }
        context.sendThenDeleteMessageAsync(text: "未找到名为 \(arg) 的用户。")
    } else {
        guard let tgUserId = context.fromId else { return true }

        guard let info = getUserInfoFromDatabase(tgUserId: tgUserId) else {
            // Not binded
            context.respondAsync("我不认识你，使用 /bind <ArcID> 绑定。")
            return true
        }

        deleteUserInfoFromDatabase(tgUserId: tgUserId)

        context.respondAsync("再见，\(info.content.accountInfo.name)！", replyToMessageId: context.message?.messageId)
    }

    return true
}
