import Foundation
import TelegramBotSDK

func beginHandler(context: Context) -> Bool {

	if context.privateChat {
		// in private chat
		context.respondAsync("本功能仅支持在群组中使用。", replyToMessageId: context.message?.messageId)
		return true
	}

	guard context.fromId != nil else { 
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

	if multiplay.started {
		context.respondAsync("多人运动正在进行中。", replyToMessageId: context.message?.messageId)
		return true
	}

	let newMultiplay = Multiplay(started: true, song: multiplay.song, players: multiplay.players)

	saveMultiplay(multiplay: newMultiplay, room: room)
	var mentionList = ""
	for player in newMultiplay.players {
		guard let info = getUserInfoFromDatabase(tgUserId: player) else { return true }
		mentionList += "[@\(info.content.name)](tg://user?id=\(player)) "
	}

	context.respondAsync("\(mentionList)\n多人游戏已开始！", parseMode: .markdown, replyToMessageId: context.message?.messageId)

	return true
}