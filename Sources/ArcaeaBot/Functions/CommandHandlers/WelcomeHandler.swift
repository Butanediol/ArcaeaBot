import Foundation
import TelegramBotSDK

func welcomeHandler(context: Context) -> Bool {
    guard let message = context.message, let newUsers = message.newChatMembers else { return true }
    guard let chat = context.bot.getChatSync(chatId: .chat(context.chatId ?? 0)) else { return true }

    if newUsers.contains(where: { user in // check self
        user.id == context.bot.getMeSync()?.id
    }) {
        /*
         guard let botAdmin = context.bot.getChatMemberSync(chatId: .chat(chat.id), userId: 254_213_545) else {
             // chat contains bot admin?
             print("cannot get chat member")
             context.sendThenDeleteMessageAsync(text: "Unauthorized chat, leaving...")
             context.bot.leaveChatAsync(chatId: .chat(chat.id))
             return true
         }
         if [ChatMember.Status.kicked, ChatMember.Status.left, ChatMember.Status.restricted].contains(botAdmin.status) {
             context.sendThenDeleteMessageAsync(text: "Unauthorized chat, leaving...")
             context.bot.leaveChatAsync(chatId: .chat(chat.id))
         }
         */
        return true
    }

    // Real new members
    for user in newUsers {
        if let info = getUserInfoFromDatabase(tgUserId: user.id) {
            context.sendThenDeleteMessageAsync(text: "你好\(info.rank)\(info.content.name)。")
        } else {
            context.sendThenDeleteMessageAsync(text: "你好，\(user.firstName + (user.lastName ?? ""))，欢迎来到\(chat.title ?? "")，使用 /bind <ArcID/ArcName> 来绑定 Arcaea 账号。")
        }
    }
    return true
}
