import Foundation
import TelegramBotSDK

func best30Handler(context: Context) -> Bool {
    context.sendChatActionAsync(action: "typing")

    guard let tgUserId = context.fromId else { return true }
    guard let info = getUserInfoFromDatabase(tgUserId: tgUserId) else {
        context.respondAsync("我不认识你，使用 /bind <ArcID/ArcName> 绑定。", replyToMessageId: context.message?.messageId)
        return true
    }
    let args = context.args.scanWords()
    if args.isEmpty {
        getUserBest30(user: .userName(info.content.name)) { result in
            switch result {
            case let .success(b30):
                saveBest30(b30: b30, user: info.content.userID)
                context.respondAsync(b30RespondText(from: b30), parseMode: .markdown, replyToMessageId: context.message?.messageId)
            case let .failure(apiError):
                requestFailureHandler(context: context, error: apiError)
            }
        }
    } else {
        guard let b30 = getBest30FromDatabase(user: info.content.userID) else {
            context.sendThenDeleteMessageAsync(text: "没有已保存的 Best30 数据", replyToMessageId: context.message?.messageId)
            return true
        }
        context.respondAsync(b30RespondText(from: b30, fromDatabase: true), parseMode: .markdown, replyToMessageId: context.message?.messageId)
    }

    context.askForCarrot(0.3)
    return true
}

func b30RespondText(from b30: UserBest30, fromDatabase: Bool = false) -> String {
    var respondText = """
    B30 Avg. `\(b30.content.best30Avg)`
    R10 Avg. `\(b30.content.recent10Avg)`\n\n
    """

    for index in b30.content.best30List.indices {
        let play = b30.content.best30List[index]
        let rank = b30.content.best30List.rankingWithTie(index: index) {
            $0.rating == $1.rating
        }
        respondText += String(format: "⎾%@ `%@` %@\n⎿%.2f %d\n", intToStringRank(i: rank + 1), play.songID, play.difficulty.abbr.uppercased(), play.rating, play.score)
    }

    return respondText + (fromDatabase ? "\n\n来自已经记录的 B30 数据" : "")
}
