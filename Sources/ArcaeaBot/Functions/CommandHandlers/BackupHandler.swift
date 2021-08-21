import Foundation
import TelegramBotSDK

func backupHandler(context: Context) -> Bool {

	if context.fromId != 254213545 { return true }

	guard let chatId = context.chatId else { return true }

	defer {
		context.respondAsync("Backup Finished.")
	}

	let allUserInfo = getAllUserInfo()
	let dict = allUserInfo.reduce(into: [:]) { $0[String($1.0)] = $1.1 }
	guard let data = try? JSONEncoder().encode(dict) else { return true }
	let backupFile = InputFile(filename: "backup.json", data: data)
	context.bot.sendDocumentAsync(chatId: .chat(chatId), document: .inputFile(backupFile))
	return true
}