import Foundation

extension String {
	func toArcDifficulty() -> Int? {
		var ratingPlus = false 
		if self.contains("+") { ratingPlus = true }

		let subSeq = String.SubSequence(self)

		let part = subSeq.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
		print(part)

		if let intVal = Int(part) {

		    return (intVal * 2) + (ratingPlus ? 1 : 0)
		} else {
			return nil
		}
	}
}