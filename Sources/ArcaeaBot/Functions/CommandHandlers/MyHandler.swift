import Foundation
import TelegramBotSDK

func myHandler(context: Context) -> Bool {
    guard let tgUserId = context.fromId else { return true }
    guard let info = getUserInfoFromDatabase(tgUserId: tgUserId), let usercode = info.content.accountInfo.code.toUsercode() else {
        context.respondAsync("我不认识你，使用 /bind <ArcID> 绑定。", replyToMessageId: context.message?.messageId)
        return true
    }
    guard let songname = context.args.scanWord() else {
        context.respondAsync("/my <Song>", replyToMessageId: context.message?.messageId)
        return true
    }

    var difficulty: Difficulty?
    if let diffArg = context.args.scanWord() {
        switch diffArg.lowercased() {
        case "pst", "past", "ps":
            difficulty = .past
        case "prs", "present", "pr":
            difficulty = .present
        case "ftr", "future", "f":
            difficulty = .future
        case "byd", "beyond", "b":
            difficulty = .beyond
        default:
            difficulty = nil
        }
    }

    getUserBest(user: .userCode(usercode), songname: songname, difficulty: difficulty ?? .future) { result in
        context.sendChatActionAsync(action: "typing")
        switch result {
        case let .success(best):
            getSongInfo(search: best.content.songID) { result in
                switch result {
                case let .success(songInfo):
                    let ratingReal = songInfo.content.difficulties[best.content.difficulty.rawValue].realrating
                    let play = best.content
                    let respondText = """
                    Name: `\(info.content.accountInfo.name)`
                    PTT: `\(String(format: "%.2f", Double(info.content.accountInfo.rating) / 100))`

                    Recent Play: \(Date(timeIntervalSince1970: Double(play.timePlayed) / 1000).formattedString(identifier: context.message?.from?.languageCode))
                    Song: `\(songlist.safeGetSongTitle(id: play.songID).en)`
                    Difficulty: `\(play.difficulty.name.capitalized) \(String(format: "%.1f", ratingReal))`
                    Play PTT: `\(String(format: "%.2f", play.rating))`
                    Score: `\(play.score)`
                    Pure: `\(play.perfectCount)(+\(play.shinyPerfectCount))`
                    Far: `\(play.nearCount)`
                    Lost: `\(play.missCount)`
                    """

                    context.respondAsync(respondText, parseMode: .markdown, replyToMessageId: context.message?.messageId)
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
