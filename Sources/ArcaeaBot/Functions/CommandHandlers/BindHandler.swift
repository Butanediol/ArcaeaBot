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
        case let .success(info):
            saveUserInfo(info: info, tgUserId: tgUserId)
            context.respondAsync("绑定成功，你好\(info.rank)\(info.content.name)！", replyToMessageId: context.message?.messageId)

        case let .failure(apiError):
            requestFailureHandler(context: context, error: apiError)
        }
    }

    return true
}
