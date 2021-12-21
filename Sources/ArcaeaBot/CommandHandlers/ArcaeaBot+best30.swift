import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func best30(context: Context) throws -> Bool {

		guard let telegramUserId = context.fromId else {
			ArcaeaBot.logger.info("Get telegram user id failed.")
			return true
		}

		guard let user = userManager.getUser(telegramUserId: telegramUserId) else {
			context.respondSync("You have not binded yet. Try /bind .")
			return true
		}

		api.get(endpoint: .best(user.arcaeaFriendCode)) { (result: Result<Best30Response, Error>) in
			switch result {
				case .success(let b30response):

					// Best 30 average ptt
					let avg = b30response.best30.reduce(into: 0) { result, play in
							result += play.potentialValue ?? 0
						} / Double(b30response.best30.count)

					let r10 = 4 * Double(user.userInfo.potential) / 100 - avg * 3

					var replyText = """
					B30 Avg: \(String(format: "%.2f", avg))
					R10 Avg: \(String(format: "%.2f", r10))\n
					"""

					for index in b30response.best30.indices {
						let play = b30response.best30[index]
						let song = self.arcSong.getSong(sid: play.songID)
						let songName = song?.nameEn ?? play.songID

						replyText += """
						⎾\(String(format: "%02d", index + 1)) \(songName) \(play.difficulty.abbr.uppercased()) \(song?.constant(of: play.difficulty) ?? -1)
						⎿\(play.score) \(Double(play.potentialValue ?? -1).formatString(with: 2))\n
						"""
					}

					context.respondSync(replyText)

				case .failure(let error):
					context.respondSync("\(error.localizedDescription)")
			}
		}

		return true
	}

}