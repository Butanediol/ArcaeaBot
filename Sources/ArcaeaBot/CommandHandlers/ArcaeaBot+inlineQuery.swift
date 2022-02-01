import Foundation
import TelegramBotSDK

extension ArcaeaBot {
	func inlineQueryHandler(_ query: InlineQuery) {
		var inlineQueryResultArticles: [InlineQueryResultArticle] = []
		defer {
			bot.answerInlineQueryAsync(
				inlineQueryId: query.id, 
				results: inlineQueryResultArticles.map {
					InlineQueryResult.article($0)
				},
				cacheTime: 60
			)
		}

		let telegramUserId = query.from.id
		guard let user = userManager.getUser(telegramUserId: telegramUserId) else {
			inlineQueryResultArticles.append(
	            InlineQueryResultArticle(
	                type: "article",
	                id: UUID().uuidString,
	                title: Prompts.notBind.rawValue,
	                inputMessageContent: .text(InputTextMessageContent(messageText: "You have not bind yet. Try send bind in private message."))
	            )
	        )
			return
		}

		let sema = DispatchSemaphore(value: 0)

		api.get(endpoint: .userInfo(user.arcaeaFriendCode)) { (result: Result<UserInfoResponse, Error>) in
			switch result {
			case .success(let userInfoResponse):
				self.userManager.updateUserInfo(telegramUserId: telegramUserId, userInfo: userInfoResponse.userInfo)

				let play = userInfoResponse.userInfo.lastPlayedSong
				let song = self.arcSong.getSong(sid: play.songID)

				let userPtt = user.userInfo.potential != nil ? String(Double(user.userInfo.potential!) / 100) : "Hidden"
				let playPtt = song?.playPtt(difficulty: play.difficulty, score: play.score) ?? 0
				let playDate = Date(timeIntervalSince1970: Double(play.timePlayed / 1000))

				let formatter = RelativeDateTimeFormatter()
				formatter.locale = Locale(identifier: query.from.languageCode ?? "en_US")
				let relativeTimeString = formatter.localizedString(for: playDate, relativeTo: Date())

				let replyText = """
				\(user.userInfo.displayName)(\(userPtt)) played `\(song?.nameEn ?? play.songID)` \(relativeTimeString)

				Difficulty: \(play.difficulty.fullName) (\((song?.constant(of: play.difficulty) ?? -1).formatString(with: 1)))
				Score: \(play.score)
				PlayPTT: \(playPtt.formatString(with: 2))
				\(play.pureCount) (+\(play.shinyPureCount)) / \(play.farCount) / \(play.lostCount)
				"""

				inlineQueryResultArticles.append(
                    InlineQueryResultArticle(
                        type: "article",
                        id: UUID().uuidString,
                        title: "Recent Play",
                        inputMessageContent: .text(InputTextMessageContent(messageText: replyText, parseMode: .markdown))
                    )
                )
			case .failure(let error):
				inlineQueryResultArticles.append(
                    InlineQueryResultArticle(
                        type: "article",
                        id: UUID().uuidString,
                        title: "Error",
                        inputMessageContent: .text(InputTextMessageContent(messageText: error.localizedDescription, parseMode: .markdown))
                    )
                )
			}
			sema.signal()
		}
		sema.wait()
	}
}