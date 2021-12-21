import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func my(context: Context) throws -> Bool {

		guard let telegramUserId = context.fromId else {
			ArcaeaBot.logger.info("Get telegram user id failed.")
			return true
		}

		guard let user = userManager.getUser(telegramUserId: telegramUserId) else {
			context.respondSync("You have not binded yet. Try /bind .")
			return true
		}

		guard let songId = context.args.scanWord() else {
			context.respondSync("Usage:\n/my <SongId> [Difficulty]")
			return true
		}

		var diff = Difficulty.future
		if let difficulty = context.args.scanWord() {
			switch difficulty {
				case "past", "pst", "1":
					diff = .past
				case "present", "prs", "2":
					diff = .present
				case "future", "ftr", "3":
					diff = .future
				case "beyond", "byd", "4":
					diff = .beyond
				default:
					diff = .future
			}
		}

		api.get(endpoint: .score(diff, user.arcaeaFriendCode, songId), paramaters: [:]) { (result: Result<BestPlayResponse, Error>) in
			switch result {
				case .success(let bestPlayResponse):
					let play = bestPlayResponse.bestPlay
					let song = self.arcSong.getSong(sid: play.songID)

					let playPtt = song?.playPtt(difficulty: diff, score: play.score) ?? 0

					let replyText = """
					\(user.userInfo.displayName) \(Double(user.userInfo.potential) / 100)
					Song: \(song?.nameEn ?? play.songID)
					Difficulty: \(play.difficulty.fullName) (\((song?.constant(of: play.difficulty) ?? -1).formatString(with: 1)))
					Score: \(play.score)
					PlayPTT: \(playPtt.formatString(with: 2))
					P/F/L
					\(play.pureCount)+\(play.shinyPureCount)/\(play.farCount)/\(play.lostCount)
					"""

					context.respondSync(replyText)
				case .failure(let error):
					context.respondSync("\(error.localizedDescription)")
			}
		}

		return true
	}

}