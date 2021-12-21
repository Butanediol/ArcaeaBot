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
					let avg = b30response.best30.reduce(into: 0) { result, play in
							result += play.potentialValue ?? 0
						} / Double(b30response.best30.count)
					context.respondSync(
						"B30 Avg: \(String(format: "%.2f", avg))\n" +
						b30response.best30.map { play in
							let song = self.arcSong.getSong(sid: play.songID)
							let songName = song?.nameEn ?? play.songID

							return """
							⎾\(songName) \(play.difficulty.abbr.uppercased()) \(song?.constant(of: play.difficulty) ?? -1)
							⎿\(play.score) \(Double(play.potentialValue ?? -1).formatString(with: 2))
							"""
						}.joined(separator: "\n")
					)

				case .failure(let error):
					context.respondSync("\(error.localizedDescription)")
			}
		}

		return true
	}

}