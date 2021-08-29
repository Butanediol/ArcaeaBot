import Foundation
import TelegramBotSDK

func rankHandler(context: Context) -> Bool {
    // Currently not available

    let adminList: [Int64] = [803_217_365, 254_213_545]

    guard let fromId = context.fromId, adminList.contains(fromId) else { return true }

    var respondText = ""

    let allUserInfo = getAllUserInfo()

    for index in allUserInfo.indices {
        let (tgUserId, userInfo) = allUserInfo[index]
        if userInfo.status == -1 {
            deleteUserInfoFromDatabase(tgUserId: tgUserId)
        }
        let rank = allUserInfo.rankingWithTie(index: index) {
            $0.1.content.rating == $1.1.content.rating
        }
        respondText += String(format: "%@ %@ %.2f\n", intToStringRank(i: rank + 1), userInfo.content.name, Double(userInfo.content.rating) / 100)
    }

    context.respondAsync(respondText, replyToMessageId: context.message?.messageId) { message, _ in
        if let chatId = context.chatId, let message = message {
            deleteMessageAfter(deadline: .now() + 30, bot: bot, chatId: .chat(chatId), messageId: message.messageId)
        }
    }

    return true
}
