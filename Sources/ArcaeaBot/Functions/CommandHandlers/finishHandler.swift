import Foundation
import TelegramBotSDK

func finishHandler(context: Context) -> Bool {

	let forceFlag = (context.args.scanWord()?.lowercased() == "force") ? true : false

	if context.privateChat {
		// in private chat
		context.respondAsync("本功能仅支持在群组中使用。", replyToMessageId: context.message?.messageId)
		return true
	}

	guard let tgUserId = context.fromId else { 
		context.respondAsync("无法获取用户 ID。", replyToMessageId: context.message?.messageId)
		return true 
	}

	guard let room = context.chatId else {
		context.respondAsync("无法获取对话 ID。", replyToMessageId: context.message?.messageId)
		return true
	}

	guard let multiplay = getMultiplayFromDatabase(room: room) else {
		context.respondAsync("当前对话没有正在进行的多人游戏。", replyToMessageId: context.message?.messageId)
		return true
	}

	if !multiplay.started {
		context.respondAsync("多人游戏未开始。", replyToMessageId: context.message?.messageId)
		return true
	}

	guard let info = getUserInfoFromDatabase(tgUserId: tgUserId), let usercode = info.content.code.toUsercode() else {
		context.respondAsync("获取用户数据错误")
		return true
	}

	if !multiplay.players.contains(tgUserId) {
		context.respondAsync("你并不在本场多人游戏中。", replyToMessageId: context.message?.messageId)
		return true
	}

	getUserInfo(user: .userCode(usercode), recent: 1) { result in
		switch result {
			case.success(let info):
				guard let play = info.content.recentScore.first else {
					context.respondAsync("获取成绩失败。")
					return
				}

				if play.songID != multiplay.song {
					context.respondAsync("歌曲不正确。")
					return
				}

				var result = multiplay.result
				result[tgUserId] = play
				let newMultiplay = Multiplay(started: true, song: multiplay.song, players: multiplay.players, result: result)

				if (newMultiplay.players.count == newMultiplay.result.count) || forceFlag {
					// multiplay finished
					finishMultiplay(context: context, multiplay: newMultiplay)
					deleteMultiplay(room: room)
				} else {
					// multiplay not finished
					var respondText = "请等待其他玩家完成游戏。未完成玩家(\(newMultiplay.result.count)/\(newMultiplay.players.count))：\n"
					for player in newMultiplay.players {
						if !newMultiplay.result.keys.contains(player) {
							let name = getUserInfoFromDatabase(tgUserId: player)!.content.name
							respondText += "\n- \(name)"
						}
					}
					context.respondAsync(respondText, replyToMessageId: context.message?.messageId)
					saveMultiplay(multiplay: newMultiplay, room: room)
				}

			case .failure(let apiError):
				context.respondAsync(apiError.message.capitalized)
		}

	}

	return true
}

func finishMultiplay(context: Context, multiplay: Multiplay) {

	var respondText = """
	游戏结束。
	曲目：`\(multiplay.song)`
	"""

	let results = multiplay.result.sorted {
		return $0.value.score > $1.value.score
	}

	for index in results.indices {
		guard let info = getUserInfoFromDatabase(tgUserId: results[index].key) else { return /* never happen */}
		respondText += "\n\(intToStringRank(i: index + 1)) \(info.content.name) \(results[index].value.score) \(results[index].value.difficulty.abbr.uppercased())"
	}

	context.respondAsync(respondText, parseMode: .markdown)
}