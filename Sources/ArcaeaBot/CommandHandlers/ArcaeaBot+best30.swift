import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func best30(context: Context) throws -> Bool {

		guard let telegramUserId = context.fromId else {
			ArcaeaBot.logger.info("Get telegram user id failed.")
			return true
		}

		guard let user = userManager.getUser(telegramUserId: telegramUserId) else {
			context.respondAsync("You have not bind yet. Try send bind in private message.")
			return true
		}

		api.get(endpoint: .best(user.arcaeaFriendCode)) { (result: Result<Best30Response, Error>) in
			switch result {
				case .success(let b30response):

					// Best 30 average ptt
					let avg = b30response.best30.reduce(into: 0) { result, play in
							result += play.potentialValue ?? 0
						} / Double(b30response.best30.count)

					var replyText = """
					B30 Avg: \(String(format: "%.2f", avg))
					"""

					if let userPtt = user.userInfo.potential {
						let r10 = 4 * Double(userPtt) / 100 - avg * 3
						replyText += "\nR10 Avg: \(String(format: "%.2f", r10))\n"
					} else {
						replyText += "\n"
					}

					for index in b30response.best30.indices {
						let play = b30response.best30[index]
						let song = self.arcSong.getSong(sid: play.songID)
						let songName = song?.nameEn ?? play.songID

						replyText += """
						⎾\(String(format: "%02d", index + 1)) \(songName) \(play.difficulty.abbr.uppercased()) \(song?.constant(of: play.difficulty) ?? -1)
						⎿\(play.score) \(Double(play.potentialValue ?? -1).formatString(with: 2))\n
						"""
					}

					context.respondAsync(replyText)

				case .failure(let error):
					context.respondAsync("\(error.localizedDescription)")
			}
		}

		return true
	}

}