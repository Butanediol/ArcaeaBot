import Foundation
import ArgumentParser
import TelegramBotSDK
import Logging
import SQLite

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

	var arcSong: Arcsongs
	var arcSongAlias: [String:[String]]

	static let logger = Logger(label: "ArcaeaBot")

	init(using bot: TelegramBot, userManager: UserManager, api: ArcaeaLimitedApi) {
		self.bot = bot
		self.router = Router(bot: self.bot)
		self.userManager = userManager
		self.api = api

		self.arcSong = []
		self.arcSongAlias = [:]
	}

	func run() throws {
		setUpHandlers()
		setUpArcsongs()
		setUpAlias()

		while let update = bot.nextUpdateSync() {
			try router.process(update: update)
		}
	}

	private func setUpAlias() {
		guard let path = Bundle.module.url(forResource: "arcsong", withExtension: "db") else { return }
		do {
			let db = try Connection(path.absoluteString)

			let aliases = Table("alias")
			let sid = Expression<String>("sid")
			let alias = Expression<String>("alias")

			for row in try db.prepare(aliases) {
				if arcSongAlias.keys.contains(row[sid]) {
					arcSongAlias[row[sid]]?.append(row[alias])
				} else {
					arcSongAlias[row[sid]] = [row[alias]]
				}
			}
		} catch {
			print(error.localizedDescription)
		}
	}

	private func setUpArcsongs() {
		guard let path = Bundle.module.url(forResource: "arcsong", withExtension: "db") else { return }
		do {
			let db = try Connection(path.absoluteString)

			let songs = Table("songs")
			let sid = Expression<String>("sid")
			let name_en = Expression<String>("name_en")
			let rating_pst = Expression<Int>("rating_pst")
			let rating_prs = Expression<Int>("rating_prs")
			let rating_ftr = Expression<Int>("rating_ftr")
			let rating_byn = Expression<Int>("rating_byn")

			for song in try db.prepare(songs) {
				arcSong.append(
					Arcsong(
						sid: song[sid], 
						nameEn: song[name_en], 
						ratingPst: Double(song[rating_pst])/10, 
						ratingPrs: Double(song[rating_prs])/10, 
						ratingFtr: Double(song[rating_ftr])/10, 
						ratingByn: Double(song[rating_byn])/10
					)
				)
			}

		} catch {
			print(error.localizedDescription)
		}
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