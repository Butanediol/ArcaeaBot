import Foundation
import TelegramBotSDK

extension ArcaeaBot {

	fileprivate func selectSong(of diff: Int, from set: Arcsongs) -> (song: Arcsong, difficulty: Difficulty)? {
		if let randomSong = set.filter({
				$0.difficultyPst == diff ||
				$0.difficultyPrs == diff ||
				$0.difficultyFtr == diff ||
				$0.difficultyByn == diff
			}).randomElement() {
			let difficulty: Difficulty
				if randomSong.difficultyPst == diff {
					difficulty = .past
				} else if randomSong.difficultyPrs == diff {
					difficulty = .present
				} else if randomSong.difficultyFtr == diff {
					difficulty = .future
				} else {
					difficulty = .beyond
				}
			return (randomSong, difficulty)
		}
		return nil
	}

	func dice(context: Context) throws -> Bool {

		var replyText = ""

		if let diff = context.args.scanWord()?.toArcDifficulty() {

			var songSet = arcSong
			if let packSetSearchText = context.args.scanWord(), let packSet = fuzzySearchPack(searchText: packSetSearchText.lowercased()){
				print("Search song in \(packSet) for difficulty \(diff)")
				songSet = arcSong.filter { $0.packSet == packSet}
			}

			if let (randomSong, difficulty) = selectSong(of: diff, from: songSet) {
				replyText = "[\(randomSong.packSet)] \(randomSong.nameEn)\n\(difficulty.abbr.uppercased()) \(randomSong.constant(of: difficulty))"
			} else {
				replyText = "No songs found that meet the criteria."
			}
		} else {
			replyText = "Not a valid difficulty."
		}

		context.sendChatActionAsync(action: "typing")
		context.respondAsync(replyText, replyToMessageId: context.message?.messageId)

		return true
	}

}