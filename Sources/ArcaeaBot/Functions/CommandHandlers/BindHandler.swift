import Foundation
import TelegramBotSDK

func bindHandler(context: Context) -> Bool {

	context.sendChatActionAsync(action: "typing")

	guard let tgUserId = context.fromId else { return true }

	if let info = getUserInfoFromDatabase(tgUserId: tgUserId) {
		// Already bind
		context.respondAsync("你好\(info.content.name)，你已经绑定过了。\n如果想解除绑定请使用 /unbind。", replyToMessageId: context.message?.messageId)
		return true
	}

	guard let bindId = context.args.scanWord() else {
		// ArcID or ArcName not given
		context.respondAsync("/bind <ArcID/ArcName>", replyToMessageId: context.message?.messageId)
		return true
	}

	var arcId: User

	if let usercode = Int(bindId), usercode.isValidArcId() {
		arcId = .userCode(usercode)
	} else {
		arcId = .userName(bindId)
	}

	getUserInfo(user: arcId, recent: 1) { result in

		switch result {
			case .success(let info):
				saveUserInfo(info: info, tgUserId: tgUserId)
				context.respondAsync("绑定成功，你好\(info.rank)\(info.content.name)！", replyToMessageId: context.message?.messageId)

			case .failure(let apiError):
				context.respondAsync(apiError.message.capitalized, replyToMessageId: context.message?.messageId)
		}
	}

	return true
}

func getMeHandler(context: Context) -> Bool {

	guard let tgUserId = context.fromId else { return true }

	if let info = getUserInfoFromDatabase(tgUserId: tgUserId) {
		context.respondAsync(
			"我认得你，你是\(info.rank) \(info.content.name)(`\(info.content.code)`)。\n" + 
			"PTT: \(Double(info.content.rating) / 100)", 
			parseMode: .markdown, 
			replyToMessageId: context.message?.messageId)
	} else {
		context.respondAsync(
			"我不认识你，使用 /bind <ArcID> 绑定。", 
			replyToMessageId: context.message?.messageId)
	}

	return true
}

