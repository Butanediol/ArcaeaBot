import Foundation
import TelegramBotSDK

func rankHandler(context: Context) -> Bool {

	// Currently not available

	if context.fromId != 254213545 { return true }

	var respondText = ""

	let allUserInfo = getAllUserInfo()
	for index in allUserInfo.indices {
		let (_, userInfo) = allUserInfo[index]
		respondText += String(format: "%@ %@ %.2f\n", intToStringRank(i: index + 1), userInfo.content.name, Double(userInfo.content.rating) / 100)
	}

	context.respondAsync(respondText, replyToMessageId: context.message?.messageId)

	return true
}