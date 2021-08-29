import Foundation
import TelegramBotSDK

func recentHandler(context: Context) -> Bool {
	context.sendChatActionAsync(action: "typing")

	guard var tgUserId: TgUserId = context.fromId else { return true }
	if let replyFrom = context.message?.replyToMessage?.from?.id {
		tgUserId = replyFrom
	}
	guard let info = getUserInfoFromDatabase(tgUserId: tgUserId), let usercode = info.content.code.toUsercode() else {
		let message = context.respondSync("我不认识\(context.message?.replyToMessage == nil ? "你" : " TA")，使用 /bind <ArcID/ArcName> 绑定。", replyToMessageId: context.message?.messageId)
		deleteMessageAfter(deadline: .now() + 15, bot: bot, chatId: .chat(context.chatId ?? 0), messageId: message?.messageId)
		return true
	}

	getUserInfo(user: .userCode(usercode), recent: 1) { result in

		switch result {
			case .success(let info):
				guard let play = info.content.recentScore.first else {
					context.respondAsync("获取最近结果出错，请重试。", replyToMessageId: context.message?.messageId)
					return
				}

				saveUserInfo(info: info, tgUserId: tgUserId)

				getSongInfo(search: play.songID) { result in

					switch result {
						case .success(let songInfo):
							let ratingReal = songInfo.content.difficulties[play.difficulty.rawValue].ratingReal
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
							updateBest30FromRecent(info, user: usercode)

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