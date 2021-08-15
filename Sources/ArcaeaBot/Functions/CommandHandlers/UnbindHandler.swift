import Foundation
import TelegramBotSDK

func unbindHandler(context: Context) -> Bool {

	context.sendChatActionAsync(action: "typing")

	guard let tgUserId = context.fromId else { return true }

	guard let info = getUserInfoFromDatabase(tgUserId: tgUserId) else {
		// Not binded
		context.respondAsync("我不认识你，使用 /bind <ArcID> 绑定。")
		return true
	}

	deleteUserInfoFromDatabase(tgUserId: tgUserId)

	context.respondAsync("再见，\(info.content.name)！", replyToMessageId: context.message?.messageId)
	
	return true
}