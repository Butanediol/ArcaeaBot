import Foundation
import TelegramBotSDK

func myHandler(context: Context) -> Bool {


	guard let tgUserId = context.fromId else { return true }
	guard let info = getUserInfoFromDatabase(tgUserId: tgUserId), let usercode = info.content.code.toUsercode() else {
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
			case .success(let best):
				getSongInfo(search: best.content.songID) { result in
					switch result {
						case .success(let songInfo):
							let ratingReal = songInfo.content.difficulties[best.content.difficulty.rawValue].ratingReal
							let play = best.content
							let respondText = """
							Name: `\(info.content.name)`
							PTT: `\(String(format: "%.2f", Double(info.content.rating) / 100))`

							Recent Play: \(Date(timeIntervalSince1970: Double(play.timePlayed) / 1000).formattedString())
							Song: `\(play.songID)`
							Difficulty: `\(play.difficulty.name.capitalized) \(String(format: "%.1f", ratingReal))`
							Play PTT: `\(String(format: "%.2f", play.rating))`
							Score: `\(play.score)`
							Pure: `\(play.perfectCount)(+\(play.shinyPerfectCount))`
							Far: `\(play.nearCount)`
							Lost: `\(play.missCount)`
							"""

							context.respondAsync(respondText, parseMode: .markdown, replyToMessageId: context.message?.messageId)
						case .failure(let apiError):
							requestFailureHandler(context: context, error: apiError)
					}
				}
				

			case .failure(let apiError):
				requestFailureHandler(context: context, error: apiError)
		}
		
	}
	
	return true
}