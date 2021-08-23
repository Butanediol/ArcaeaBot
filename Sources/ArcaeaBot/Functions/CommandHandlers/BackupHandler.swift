import Foundation
import TelegramBotSDK

func backupHandler(context: Context) -> Bool {

	if context.fromId != 254213545 { return true }

	guard let chatId = context.chatId else { return true }

	let placeholderMessage = context.respondSync("备份中")

	defer {
		context.bot.editMessageTextSync(chatId: .chat(chatId), messageId: placeholderMessage?.messageId, text: "备份完成")
	}

	let currentPath = FileManager().currentDirectoryPath
	let currentPathURL = URL(fileURLWithPath: currentPath).appendingPathComponent("db")
	let dbDataPathURL = currentPathURL.appendingPathComponent("data.mdb")
	let dbLockPathURL = currentPathURL.appendingPathComponent("lock.mdb")
	if let dbDataData = try? Data(contentsOf: dbDataPathURL) {
		context.bot.editMessageTextSync(chatId: .chat(chatId), messageId: placeholderMessage?.messageId, text: "备份 \(dbDataPathURL)")
		let dbDataBackupFile = InputFile(filename: "data.mdb", data: dbDataData)
		context.bot.sendDocumentAsync(chatId: .chat(chatId), document: .inputFile(dbDataBackupFile))
	}
	if let dbLockData = try? Data(contentsOf: dbDataPathURL) {
		context.bot.editMessageTextSync(chatId: .chat(chatId), messageId: placeholderMessage?.messageId, text: "备份 \(dbLockPathURL)")
		let dbDataBackupFile = InputFile(filename: "lock.mdb", data: dbLockData)
		context.bot.sendDocumentAsync(chatId: .chat(chatId), document: .inputFile(dbDataBackupFile))
	}

	return true
}