import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func recent(context: Context) throws -> Bool {

		guard let telegramUserId = context.fromId else {
			ArcaeaBot.logger.info("Get telegram user id failed.")
			return true
		}

		guard let user = userManager.getUser(telegramUserId: telegramUserId) else {
			return guardUser(context: context)
		}

		api.get(endpoint: .userInfo(user.arcaeaFriendCode)) { (result: Result<UserInfoResponse, Error>) in
			context.sendChatActionAsync(action: "typing")
			switch result {
				case .success(let userInfoResponse):
					self.userManager.updateUserInfo(telegramUserId: telegramUserId, userInfo: userInfoResponse.userInfo)

					let play = userInfoResponse.userInfo.lastPlayedSong
					let song = self.arcSong.getSong(sid: play.songID)

					let userPtt = user.userInfo.potential != nil ? String(Double(user.userInfo.potential!) / 100) : "Hidden"
					let playPtt = song?.playPtt(difficulty: play.difficulty, score: play.score) ?? 0
					let playDate = Date(timeIntervalSince1970: Double(play.timePlayed / 1000))

					let formatter = RelativeDateTimeFormatter()
					formatter.locale = Locale(identifier: context.message?.from?.languageCode ?? "en_US")
					let relativeTimeString = formatter.localizedString(for: playDate, relativeTo: Date())

					let replyText = """
					\(user.userInfo.displayName)(\(userPtt)) played `\(song?.nameEn ?? play.songID)` \(relativeTimeString)

					Difficulty: \(play.difficulty.fullName) (\((song?.constant(of: play.difficulty) ?? -1).formatString(with: 1)))
					Score: \(play.score)
					PlayPTT: \(playPtt.formatString(with: 2))
					\(play.pureCount) (+\(play.shinyPureCount)) / \(play.farCount) / \(play.lostCount)
					"""

					context.respondAsync(replyText, parseMode: .markdown, replyToMessageId: context.message?.messageId)
				case .failure(let error):
					context.respondAsync("Error: \(error.localizedDescription)", replyToMessageId: context.message?.messageId)
			}
		}

		return true
	}

}