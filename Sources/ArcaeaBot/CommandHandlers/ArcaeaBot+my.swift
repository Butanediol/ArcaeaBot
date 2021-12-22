import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	func my(context: Context) throws -> Bool {

		guard let telegramUserId = context.fromId else {
			ArcaeaBot.logger.info("Get telegram user id failed.")
			return true
		}

		guard let user = userManager.getUser(telegramUserId: telegramUserId) else {
			context.respondAsync("You have not bind yet. Try send bind in private message.")
			return true
		}

		guard let searchText = context.args.scanWord(), let songId = fuzzySearchSong(searchText: searchText) else {
			context.respondAsync("Usage:\n/my <SongName/SongId/SongAlias/SongIdFuzzySearch> [Difficulty]")
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

					let userPtt = user.userInfo.potential != nil ? String(Double(user.userInfo.potential!) / 100) : "Hidden"
					let playPtt = song?.playPtt(difficulty: diff, score: play.score) ?? 0
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

					context.respondAsync(replyText, parseMode: .markdown)
				case .failure(let error):
					context.respondAsync("\(error.localizedDescription)")
			}
		}

		return true
	}

}