import Foundation
import TelegramBotSDK

func best30Handler(context: Context) -> Bool {
	context.sendChatActionAsync(action: "typing")

	guard let tgUserId = context.fromId else { return true }
	guard let info = getUserInfoFromDatabase(tgUserId: tgUserId) else {
		context.respondAsync("我不认识你，使用 /bind <ArcID/ArcName> 绑定。", replyToMessageId: context.message?.messageId)
		return true
	}

	getUserBest30(user: .userName(info.content.name)) { result in

		switch result {
			case .success(let b30):
				var respondText = """
				B30 Avg. `\(b30.content.best30Avg)`
				R10 Avg. `\(b30.content.recent10Avg)`\n\n
				"""

				for index in b30.content.best30List.indices {
					let play = b30.content.best30List[index]
					respondText += String(format:"%@ `%@` %@\n%.2f %d\n", intToStringRank(i: index + 1), play.songID, play.difficulty.abbr.uppercased(), play.rating, play.score)
				}
				context.respondAsync(respondText, parseMode: .markdown, replyToMessageId: context.message?.messageId)
			case .failure(let apiError):
				context.respondAsync(apiError.message.capitalized, replyToMessageId: context.message?.messageId)
		}
		
	}

	return true
}