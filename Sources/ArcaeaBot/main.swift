import Foundation
import TelegramBotSDK

signal(SIGINT) {
    print("\nSee you next time. Signal \($0).")
    exit($0)
}

try! multiplayDatabase.drop()

let startTime = Date()
var requestCount = 0
var errorRequestCount = 0

let bot = TelegramBot(token: token)
var router = Router(bot: bot)

router[.command(Command("recent", options: .slashRequired))] = recentHandler
router[.command(Command("bind", options: .slashRequired))] = bindHandler
router[.command(Command("unbind", options: .slashRequired))] = unbindHandler
router[.command(Command("me", options: .slashRequired))] = getMeHandler
router[.command(Command("best30", options: .slashRequired))] = best30Handler
router[.command(Command("b30", options: .slashRequired))] = best30Handler
router[.command(Command("my", options: .slashRequired))] = myHandler
router[.command(Command("help", options: .slashRequired))] = helpHandler
router[.command(Command("start", options: .slashRequired))] = helpHandler
router[.command(Command("multiplay", options: .slashRequired))] = multiplayHandler
router[.command(Command("join", options: .slashRequired))] = joinHandler
router[.command(Command("begin", options: .slashRequired))] = beginHandler
router[.command(Command("finish", options: .slashRequired))] = finishHandler
router[.command(Command("cancel", options: .slashRequired))] = cancelHandler
router[.command(Command("roll", options: .slashRequired))] = rollHandler
router[.command(Command("statistics", options: .slashRequired))] = statisticsHelper
router[.command(Command("rank", options: .slashRequired))] = rankHandler

router[.newChatMembers] = welcomeHandler
router[.leftChatMember] = goodbyeHandler

router[.command(Command("backup", options: .slashRequired))] = backupHandler

while let update = bot.nextUpdateSync() {
    try router.process(update: update)

    if let inlineQuery = update.inlineQuery {
        DispatchQueue.main.async {
            inlineQueryHandler(inlineQuery: inlineQuery)
        }
    }
}

fatalError("Server stopped due to error: \(String(describing: bot.lastError))")
