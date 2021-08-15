import Foundation

extension Date {
	func formattedString() -> String {

		let timeInterval = Int(Date().timeIntervalSince1970 - self.timeIntervalSince1970)
		let seconds = timeInterval % 60
		let minutes = timeInterval / 60 % 60
		let hours = timeInterval / 60 / 60 % 24
		let days = timeInterval / 60 / 60 / 24 % 30
		let months = timeInterval / 60 / 60 / 24 / 30 % 12
		let years = timeInterval / 60 / 60 / 24 / 365 % 100

		let list: [String] = [
			years == 0   ? "" : "\(years) 年",
			months == 0  ? "" : "\(months) 月",
			days == 0    ? "" : "\(days) 天",
			hours == 0   ? "" : "\(hours) 小时",
			minutes == 0 ? "" : "\(minutes) 分钟",
			seconds == 0 ? "" : "\(seconds) 秒"
		]

		return String(format: "%@前", list.joined(separator: " "))
	}
}