import Foundation

extension Date {
    func formattedString() -> String {
        var timeInterval = Int(Date().timeIntervalSince1970 - timeIntervalSince1970)
        var minusFlag = false

        if timeInterval < 0 {
            timeInterval = -timeInterval
            minusFlag = true
        }

        let seconds = timeInterval % 60
        let minutes = timeInterval / 60 % 60
        let hours = timeInterval / 60 / 60 % 24
        let days = timeInterval / 60 / 60 / 24 % 30
        let months = timeInterval / 60 / 60 / 24 / 30 % 12
        let years = timeInterval / 60 / 60 / 24 / 365 % 100

        let list: [String] = [
            years == 0 ? "" : "\(years) 年",
            months == 0 ? "" : "\(months) 月",
            days == 0 ? "" : "\(days) 天",
            hours == 0 ? "" : "\(hours) 小时",
            minutes == 0 ? "" : "\(minutes) 分钟",
            seconds == 0 ? "" : "\(seconds) 秒",
        ]

        return String(format: "%@%@", list.joined(separator: " ").trimmed(), minusFlag ? "后" : "前")
    }
}
