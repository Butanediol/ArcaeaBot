import Foundation
import TelegramBotSDK

func recentHandler(context: Context) -> Bool {
    context.sendChatActionAsync(action: "typing")

    guard var tgUserId: TgUserId = context.fromId else { return true }
    if let replyFrom = context.message?.replyToMessage?.from?.id {
        tgUserId = replyFrom
    }
    guard let info = getUserInfoFromDatabase(tgUserId: tgUserId), let usercode = info.content.code.toUsercode() else {
        context.sendThenDeleteMessageAsync(text: "我不认识\(context.message?.replyToMessage == nil ? "你" : " TA")，使用 /bind <ArcID/ArcName> 绑定。", replyToMessageId: context.message?.messageId)
        return true
    }

    getUserInfo(user: .userCode(usercode), recent: 1) { result in

        switch result {
        case let .success(info):
            guard let play = info.content.recentScore.first else {
                context.respondAsync("获取最近结果出错，请重试。", replyToMessageId: context.message?.messageId)
                return
            }

            saveUserInfo(info: info, tgUserId: tgUserId)

            getSongInfo(search: play.songID) { result in

                switch result {
                case let .success(songInfo):
                    let ratingReal = songInfo.content.difficulties[play.difficulty.rawValue].ratingReal
                    let respondText = """
                    Name: `\(info.content.name)`
                    PTT: `\(String(format: "%.2f", Double(info.content.rating) / 100))`

                    Recent: \(Date(timeIntervalSince1970: Double(play.timePlayed) / 1000).formattedString())
                    Song: `\(songlist.safeGetSongTitle(id: play.songID).en)`
                    Difficulty: `\(play.difficulty.name.capitalized) \(String(format: "%.1f", ratingReal))`
                    Play PTT: `\(String(format: "%.2f", play.rating))`
                    Score: `\(play.score)`
                    Pure: `\(play.perfectCount)(+\(play.shinyPerfectCount))`
                    Far: `\(play.nearCount)`
                    Lost: `\(play.missCount)`
                    """

                    context.respondAsync(respondText, parseMode: .markdown, replyToMessageId: context.message?.messageId)
                    updateBest30FromRecent(info, user: usercode)

                case let .failure(apiError):
                    requestFailureHandler(context: context, error: apiError)
                }
            }

        case let .failure(apiError):
            requestFailureHandler(context: context, error: apiError)
        }
    }

    context.askForCarrot(0.1)
    return true
}
