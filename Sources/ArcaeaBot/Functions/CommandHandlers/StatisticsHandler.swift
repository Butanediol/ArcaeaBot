import Foundation
import TelegramBotSDK

func statisticsHelper(context: Context) -> Bool {
    let upTime = Date().timeIntervalSince(startTime)
    let responseText = """
    Uptime: \(upTime)s
    \(errorRequestCount) errors occurred out of \(requestCount) requests.
    Error rate: \(String(format: "%.2f%%", Double(errorRequestCount * 100) / Double(requestCount)))
    """
    context.sendThenDeleteMessageAsync(after: .now() + 30, text: responseText)
    return true
}
