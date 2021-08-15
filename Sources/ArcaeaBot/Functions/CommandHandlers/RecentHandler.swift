import Foundation
import TelegramBotSDK

func recentHandler(context: Context) -> Bool {
	context.sendChatActionAsync(action: "typing")

	guard let tgUserId = context.fromId else { return true }
	guard let info = getUserInfoFromDatabase(tgUserId: tgUserId), let usercode = info.content.code.toUsercode() else {
		context.respondAsync("我不认识你，使用 /bind <ArcID/ArcName> 绑定。", replyToMessageId: context.message?.messageId)
		return true
	}

	getUserInfo(user: .userCode(usercode), overflow: 1) { result in

		switch result {
			case .success(let info):
				guard let play = info.content.recentScore.first else {
					context.respondAsync("获取最近结果出错，请重试。", replyToMessageId: context.message?.messageId)
					return
				}

				getSongInfo(search: play.songID) { result in

					switch result {
						case .success(let songInfo):
							let ratingReal = songInfo.content.difficulties[play.difficulty.rawValue].ratingReal
							let respondText = """
							Name: `\(info.content.name)`
							PTT: `\(String(format: "%.2f", Double(info.content.rating) / 100))`

							Recent Play: \(Date(timeIntervalSince1970: Double(play.timePlayed) / 1000).formattedString().trimmed())
							Song: `\(play.songID)`
							Difficulty: `\(play.difficulty.name.capitalized) \(String(format: "%.1f", ratingReal))`
							Play PTT: `\(String(format: "%.2f", play.rating))`
							Score: `\(play.score)`
							Pure: `\(play.perfectCount)(+\(play.shinyPerfectCount))`
							Far: `\(play.nearCount)`
							Lost: `\(play.missCount)`
							"""
							
							context.respondAsync(respondText, parseMode: .markdown, replyToMessageId: context.message?.messageId)
							updateBest30FromRecent(info, user: usercode)

						case .failure(let apiError):
							context.respondAsync(apiError.message.capitalized, replyToMessageId: context.message?.messageId)
					}

				}

			case .failure(let apiError):
				context.respondAsync(apiError.message.capitalized, replyToMessageId: context.message?.messageId)
		}

		
	}
	
	return true
}