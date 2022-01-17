import Foundation
import TelegramBotSDK

func rankHandler(context: Context) -> Bool {
    // Currently not available

    // let adminList: [Int64] = [803_217_365, 254_213_545]
    // guard let fromId = context.fromId, adminList.contains(fromId) else { return true }

    var respondText = ""

    let allUserInfo = getAllUserInfo()

    for index in allUserInfo.indices {
        let (tgUserId, userInfo) = allUserInfo[index]
        if userInfo.status == -1 {
            deleteUserInfoFromDatabase(tgUserId: tgUserId)
        }
        let rank = allUserInfo.rankingWithTie(index: index) { a, b in
            a.1.content.accountInfo.rating == b.1.content.accountInfo.rating
            // $0.1.content.rating == $1.1.content.rating
        }
        respondText += String(format: "%@ %@ %.2f\n", intToStringRank(i: rank + 1), userInfo.content.accountInfo.rating, Double(userInfo.content.accountInfo.rating) / 100)
    }

    context.sendThenDeleteMessageAsync(after: .now() + 30, text: respondText, replyToMessageId: context.message?.messageId)

    return true
}
