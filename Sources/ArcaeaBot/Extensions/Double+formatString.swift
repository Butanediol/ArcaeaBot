import Foundation

extension Double {
	func formatString(with digits: Int) -> String {
		String(format: "%.\(digits)f", self)
	}
}