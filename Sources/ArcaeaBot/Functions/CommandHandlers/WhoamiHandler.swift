import Foundation
import TelegramBotSDK

func whoamiHandler(context: Context) -> Bool {
    guard let tgUserId = context.fromId else { return true }

    if let info = getUserInfoFromDatabase(tgUserId: tgUserId) {
        context.respondAsync(
            "我认得你，你是\(info.content.accountInfo.rank) \(info.content.accountInfo.name)(`\(info.content.accountInfo.code)`)。\n" +
                "PTT: \(Double(info.content.accountInfo.rating) / 100)",
            parseMode: .markdown,
            replyToMessageId: context.message?.messageId
        )
    } else {
        context.respondAsync(
            "我不认识你，使用 /bind <ArcID/ArcName> 绑定。",
            replyToMessageId: context.message?.messageId
        )
    }
    return true
}
