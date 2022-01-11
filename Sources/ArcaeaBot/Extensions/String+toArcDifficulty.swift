import Foundation

extension String {
    func toArcDifficulty() -> Int? {
        var ratingPlus = false
        if contains("+") { ratingPlus = true }

        let subSeq = String.SubSequence(self)

        let part = subSeq.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        if let intVal = Int(part), (1 ... 11).contains(intVal) {
            return (intVal * 2) + (ratingPlus ? 1 : 0)
        } else {
            return nil
        }
    }
}