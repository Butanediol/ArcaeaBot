import Foundation
import TelegramBotSDK

func multiplayHandler(context: Context) -> Bool {

	if context.privateChat {
		// in private chat
		context.respondAsync("本功能仅支持在群组中使用。")
		return true
	}

	guard let chatId = context.chatId else { 
		// get current chat id as a room name
		context.respondAsync("无法获取对话 ID")
		return true
	}

	guard let tgUserId = context.fromId else {
		// get sender id as first player
		context.respondAsync("无法获取用户 ID")
		return true
	}

	if getMultiplayFromDatabase(room: chatId) != nil {
		context.respondAsync("当前对话中已存在多人游戏。", replyToMessageId: context.message?.messageId)
		return true
	}

	guard let info = getUserInfoFromDatabase(tgUserId: tgUserId) else {
		// get arc user info
		context.respondAsync("我不认识你，使用 /bind <ArcID/ArcName> 绑定。", replyToMessageId: context.message?.messageId)
		return true
	}

	let helpText = """
	/multiplay
	/multiplay <Song>
	/multiplay <floor> <ceiling>
	/multiplay <floor> +
	/multiplay <ceiling> -
	"""

	let args = context.args.scanWords()

	var multiplay: Multiplay?
	let sema = DispatchSemaphore(value: 0)

	switch args.count {
		case 0:
			getRandomSong(from: 2, to: 23) { result in
				switch result {
					case .success(let randomSong):
						multiplay = Multiplay(started: false, song: randomSong.content.id, players: [tgUserId])
					case .failure(let apiError):
						context.respondAsync(apiError.message.capitalized, replyToMessageId: context.message?.messageId)
				}
				sema.signal()
			}

		case 1:
			guard let songName = args.first else { return true } // This never gonna happen.
			getSongInfo(search: songName) { result in
				switch result {
					case .success(let songInfo):
						multiplay = Multiplay(started: false, song: songInfo.content.id, players: [tgUserId])
					case .failure(let apiError):
						context.respondAsync(apiError.message.capitalized, replyToMessageId: context.message?.messageId)
				}
				sema.signal()
			}

		case 2:
			guard let arg1 = args.first, let arg2 = args.dropFirst().first else { return true } // This never gonna happen
			if let floorOrCeiling = arg1.toArcDifficulty() {
				// first argument must be arc difficulty
				if let ceiling = arg2.toArcDifficulty() {
					// second argument is also arcDiff: random from floor to ceiling
					getRandomSong(from: floorOrCeiling, to: ceiling) { result in
						switch result {
							case .success(let randomSong):
								multiplay = Multiplay(started: false, song: randomSong.content.id, players: [tgUserId])
							case .failure(let apiError):
								context.respondAsync(apiError.message.capitalized, replyToMessageId: context.message?.messageId)
						}
						sema.signal()
					}
				} else if arg2 == "+" {
					// second argument is +
					getRandomSong(from: floorOrCeiling, to: 23) { result in
						switch result {
							case .success(let randomSong):
								multiplay = Multiplay(started: false, song: randomSong.content.id, players: [tgUserId])
							case .failure(let apiError):
								context.respondAsync(apiError.message.capitalized, replyToMessageId: context.message?.messageId)
						}
						sema.signal()
					}
				} else if arg2 == "-" {
					// second argument is -
					getRandomSong(from: 2, to: floorOrCeiling) { result in
						switch result {
							case .success(let randomSong):
								multiplay = Multiplay(started: false, song: randomSong.content.id, players: [tgUserId])
							case .failure(let apiError):
								context.respondAsync(apiError.message.capitalized, replyToMessageId: context.message?.messageId)
						}
						sema.signal()
					}
				} else {
					context.respondAsync(helpText)
					sema.signal()
				}
			} else {
				// first argument is not valid, aka. not arc difficulty
				context.respondAsync(helpText)
				sema.signal()
			}

		default:
			context.respondAsync(helpText)
			sema.signal()
	}

	sema.wait()

	if let multiplay = multiplay {

		saveMultiplay(multiplay: multiplay, room: chatId)

		let respondText = """
		创建多人游戏成功！使用 /join 加入。
		房间：`\(chatId)`
		曲目：`\(multiplay.song)`
		玩家：
		- \(info.content.name)(`\(info.content.code)`)
		"""

		context.respondAsync(respondText, parseMode: .markdown, replyToMessageId: context.message?.messageId)
	}

	return true
}