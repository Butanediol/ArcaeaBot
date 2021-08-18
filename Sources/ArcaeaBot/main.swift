import Foundation
import TelegramBotSDK

let bot = TelegramBot(token: token)
var router = Router(bot: bot)

router[.command(Command("recent", options: .slashRequired))] = recentHandler
router[.command(Command("bind", options: .slashRequired))] = bindHandler
router[.command(Command("unbind", options: .slashRequired))] = unbindHandler
router[.command(Command("me", options: .slashRequired))] = getMeHandler
router[.command(Command("best30", options: .slashRequired))] = best30Handler
router[.command(Command("my", options: .slashRequired))] = myHandler
router[.command(Command("help", options: .slashRequired))] = helpHandler
router[.command(Command("start", options: .slashRequired))] = helpHandler
router[.command(Command("multiplay", options: .slashRequired))] = multiplayHandler
router[.command(Command("join", options: .slashRequired))] = joinHandler
router[.command(Command("begin", options: .slashRequired))] = beginHandler
router[.command(Command("finish", options: .slashRequired))] = finishHandler
router[.command(Command("cancel", options: .slashRequired))] = cancelHandler
router[.command(Command("rank", options: .slashRequired))] = rankHandler
router[.command(Command("event", options: .slashRequired))] = eventHandler

while let update = bot.nextUpdateSync() {
	try router.process(update: update)    
}

fatalError("Server stopped due to error: \(String(describing: bot.lastError))")