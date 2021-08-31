import Foundation
import TelegramBotSDK

extension Context {
    func askForCarrot(_ probability: Double = 0.8) {
        if Int.random(in: 1 ... 10000) <= Int(probability * 10000) {
            sendThenDeleteMessageAsync(after: .now() + 30, text: "小樱摘星机的查分功能需要一笔不是很小的开销，去给 @BotDaughter 投喂一根🥕吧！")
        }
    }
}
