import Foundation
import TelegramBotSDK

func rollHandler(context: Context) -> Bool {
    context.sendChatActionAsync(action: "typing")
    let args = context.args.scanWords()
    guard args.count == 2 else {
        context.sendThenDeleteMessageAsync(after: .now() + 30, text: "参数错误", replyToMessageId: context.message?.messageId)
        return true
    }

    guard let arg1 = args[0].toArcDifficulty(), let arg2 = args[1].toArcDifficulty() else {
        context.sendThenDeleteMessageAsync(after: .now() + 30, text: "难度错误", replyToMessageId: context.message?.messageId)
        return true
    }

    let floor = min(arg1, arg2)
    let ceiling = max(arg1, arg2)

    getRandomSong(from: floor, to: ceiling) { result in
        switch result {
        case let .success(randomSong):
            context.respondAsync("\(randomSong.content.id): \(randomSong.content.ratingClass.name)", replyToMessageId: context.message?.messageId)
        case let .failure(apiError):
            requestFailureHandler(context: context, error: apiError)
        }
    }

    return true
}
