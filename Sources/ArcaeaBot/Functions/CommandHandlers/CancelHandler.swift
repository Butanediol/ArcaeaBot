import Foundation
import TelegramBotSDK

func cancelHandler(context: Context) -> Bool {

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

	deleteMultiplay(room: room)

	context.respondAsync("已删除当前对话的多人游戏。")

	return true
}