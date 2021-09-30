import Foundation
import TelegramBotSDK

func inlineQueryHandler(inlineQuery: InlineQuery) {
    var inlineQueryResultArticles: [InlineQueryResultArticle] = []
    defer {
        bot.answerInlineQueryAsync(inlineQueryId: inlineQuery.id, results: inlineQueryResultArticles.map { InlineQueryResult.article($0) }, cacheTime: 5)
    }

    let tgUserId = inlineQuery.from.id
    guard let info = getUserInfoFromDatabase(tgUserId: tgUserId) else {
        inlineQueryResultArticles.append(
            InlineQueryResultArticle(
                type: "article",
                id: UUID().uuidString,
                title: "你还没有绑定 Arcaea 账号。",
                inputMessageContent: .text(InputTextMessageContent(messageText: "你还没有绑定 Arcaea 账号。"))
            )
        )
        return
    }

    inlineQueryResultArticles.append(
        InlineQueryResultArticle(
            type: "article",
            id: UUID().uuidString,
            title: "账号信息",
            inputMessageContent: .text(InputTextMessageContent(messageText: "\(info.content.name)(`\(info.content.code)`)", parseMode: .markdown))
        )
    )

    if let b30 = getBest30FromDatabase(user: info.content.userID) {
        inlineQueryResultArticles.append(
            InlineQueryResultArticle(
                type: "article",
                id: UUID().uuidString,
                title: "已经记录的 Best 30 数据",
                inputMessageContent: .text(InputTextMessageContent(messageText: b30RespondText(from: b30, fromDatabase: true), parseMode: .markdown))
            )
        )
    }

    let sema = DispatchSemaphore(value: 0)

    guard let userCode = info.content.code.toUsercode() else {
        return
    }

    getUserInfo(user: .userCode(userCode), recent: 1) { result in
        switch result {
        case let .success(info):
            saveUserInfo(info: info, tgUserId: tgUserId)
            if let recent = info.content.recentScore.first {
                let respondText = """
                Name: `\(info.content.name)`
                PTT: `\(String(format: "%.2f", Double(info.content.rating) / 100))`

                Recent Play: \(Date(timeIntervalSince1970: Double(recent.timePlayed) / 1000).formattedString())
                Song: `\(recent.songID)`
                Difficulty: `\(recent.difficulty.name.capitalized)`
                Play PTT: `\(String(format: "%.2f", recent.rating))`
                Score: `\(recent.score)`
                Pure: `\(recent.perfectCount)(+\(recent.shinyPerfectCount))`
                Far: `\(recent.nearCount)`
                Lost: `\(recent.missCount)`
                """

                inlineQueryResultArticles.append(
                    InlineQueryResultArticle(
                        type: "article",
                        id: UUID().uuidString,
                        title: "Recent 数据",
                        inputMessageContent: .text(InputTextMessageContent(messageText: respondText, parseMode: .markdown))
                    )
                )
            }
        case let .failure(apiError):
            print(apiError.localizedDescription)
        }
        sema.signal()
    }

    sema.wait()
}
