import Foundation
import TelegramBotSDK

func eventHandler(context: Context) -> Bool {
	context.sendChatActionAsync(action: "typing")
	getArcaeaEvent { result in
		switch result {
			case .success(let events):
				let sortedEvents = events.sorted {
					$0.from.timeIntervalSince1970 < $1.from.timeIntervalSince1970
				}

				var respondText = ""

				let onGoingEvents = sortedEvents.filter({ Date().timeIntervalSince($0.to) < 86400 * 2 })
				if onGoingEvents.isEmpty {
					context.respondAsync("暂无正在进行的活动地图", replyToMessageId: context.message?.messageId)
					return
				}

				for event in onGoingEvents {
					// ended less than 2 day
					respondText += String(
						format: "\n地图：*%@*\n%d 阶 %d 步\n奖励：%@\n结束时间：%@\n", 
						event.map, event.levels, event.steps, 
						event.prize.flatArray.joined(separator: "，"),
						event.to.formattedString()
					)
				}
				context.respondAsync(respondText.trimmed(), parseMode: .markdown, replyToMessageId: context.message?.messageId)
			case .failure(let apiError):
				context.respondAsync(apiError.message.capitalized, replyToMessageId: context.message?.messageId)
		}
	}
	return true
}