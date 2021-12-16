import Foundation
import ArgumentParser
import TelegramBotSDK
import Logging

@main
struct ArcaeaBotEntry: ParsableCommand {
	@Option(name: .shortAndLong, help: "Telegram Bot Token")
	var telegramBotToken: String

	@Option(name: .shortAndLong, help: "Arcaea Limited API Token")
	var arcaeaLimitedAPIToken: String

	@Option(name: .shortAndLong, help: "Path to user list file.")
	var usersFilePath: String = "Users.json"

	mutating func run() throws {
		let telegramBot = TelegramBot(token: telegramBotToken)
		let arcaeaBot = ArcaeaBot(using: telegramBot, userManager: UserManager(path: usersFilePath))

		try arcaeaBot.run()
	}
}

class ArcaeaBot {
	let bot: TelegramBot
	let router: Router
	let logger: Logger
	let userManager: UserManager

	init(using bot: TelegramBot, userManager: UserManager) {
		self.bot = bot
		self.router = Router(bot: self.bot)
		self.logger = Logger(label: "ArcaeaBot")
		self.userManager = userManager
	}

	func run() throws {
		setUpHandlers()

		while let update = bot.nextUpdateSync() {
			try router.process(update: update)
		}
	}

	func setUpHandlers() {
		router[.command(Command("whoami"))] = self.whoami
		router[.command(Command("bind"))] = self.bind
	}
}

protocol Localizable {
	var localizedString: String { get }
}