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
		let arcaeaLimitedAPI = ArcaeaLimitedApi(token: arcaeaLimitedAPIToken, logger: ArcaeaBot.logger)
		let arcaeaBot = ArcaeaBot(using: telegramBot, userManager: UserManager(path: usersFilePath), api: arcaeaLimitedAPI)

		try arcaeaBot.run()
	}
}

class ArcaeaBot {
	let bot: TelegramBot
	let router: Router
	let userManager: UserManager
	let api: ArcaeaLimitedApi

	static let logger = Logger(label: "ArcaeaBot")

	init(using bot: TelegramBot, userManager: UserManager, api: ArcaeaLimitedApi) {
		self.bot = bot
		self.router = Router(bot: self.bot)
		self.userManager = userManager
		self.api = api
	}

	func run() throws {
		setUpHandlers()
		test()

		while let update = bot.nextUpdateSync() {
			try router.process(update: update)
		}
	}

	func test() {

	}

	func setUpHandlers() {
		router[.command(Command("whoami"))] = self.whoami
		router[.command(Command("bind", options: [.slashRequired, .exactMatch]))] = self.bind
		router[.command(Command("unbind"))] = self.unbind
		router[.command(Command("recent"))] = self.recent
		router[.command(Command("best30"))] = self.best30
		router[.command(Command("my"))] = self.my
	}
}

protocol Localizable {
	var localizedString: String { get }
}