import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func recent(context: Context) throws -> Bool {

		guard let telegramUserId = context.fromId else {
			ArcaeaBot.logger.info("Get telegram user id failed.")
			return true
		}

		guard let user = userManager.getUser(telegramUserId: telegramUserId) else {
			context.respondAsync("You have not binded yet. Try /bind .")
			return true
		}

		api.get(endpoint: .userInfo(user.arcaeaFriendCode)) { (result: Result<UserInfoResponse, Error>) in
			switch result {
				case .success(let userInfoResponse):
					self.userManager.updateUserInfo(telegramUserId: telegramUserId, userInfo: userInfoResponse.userInfo)

					let play = userInfoResponse.userInfo.lastPlayedSong
					let song = self.arcSong.getSong(sid: play.songID)

					let playPtt = song?.playPtt(difficulty: play.difficulty, score: play.score) ?? 0

					let replyText = """
					\(user.userInfo.displayName) \(Double(user.userInfo.potential) / 100)
					Song: \(song?.nameEn ?? play.songID)
					Difficulty: \(play.difficulty.fullName) (\((song?.constant(of: play.difficulty) ?? -1).formatString(with: 1)))
					Score: \(play.score)
					PlayPTT: \(playPtt.formatString(with: 2))
					P/F/L
					\(play.pureCount)+\(play.shinyPureCount)/\(play.farCount)/\(play.lostCount)
					"""

					context.respondAsync(replyText)
				case .failure(let error):
					context.respondAsync("Error: \(error.localizedDescription)")
			}
		}

		return true
	}

}