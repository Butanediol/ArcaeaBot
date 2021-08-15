import Foundation
import TelegramBotSDK

func joinHandler(context: Context) -> Bool {

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

	guard getUserInfoFromDatabase(tgUserId: tgUserId) != nil else {
		// get arc user info
		context.respondAsync("我不认识你，使用 /bind <ArcID> 绑定。", replyToMessageId: context.message?.messageId)
		return true
	}

	guard let multiplay = getMultiplayFromDatabase(room: room) else {
		context.respondAsync("当前对话没有正在进行的多人游戏。", replyToMessageId: context.message?.messageId)
		return true
	}

	if multiplay.started {
		context.respondAsync("多人游戏已开始，请等待下一轮。", replyToMessageId: context.message?.messageId)
		return true
	}

	if multiplay.players.contains(tgUserId) {
		context.respondAsync("您已加入游戏。", replyToMessageId: context.message?.messageId)
		return true
	}

	guard let newMultiplay = joinMultiplay(room: room, tgUserId: tgUserId) else { 
		context.respondAsync("加入失败。", replyToMessageId: context.message?.messageId)
		return true 
	}

	var respondText = """
	加入房间成功！
	曲目：`\(newMultiplay.song)`
	当前玩家：
	"""
	for tgUser in newMultiplay.players {
		guard let playerInfo = getUserInfoFromDatabase(tgUserId: tgUser) else { return true } // This should never happen
		respondText += "\n- \(playerInfo.content.name)"
	}

	context.respondAsync(respondText, parseMode: .markdown, replyToMessageId: context.message?.messageId)
	

	return true
}