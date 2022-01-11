import Foundation

struct Arcsong {
	let sid: String
	let nameEn: String
	let packSet: String
	let difficultyPst: Int
	let difficultyPrs: Int
	let difficultyFtr: Int
	let difficultyByn: Int
	let ratingPst: Double
	let ratingPrs: Double
	let ratingFtr: Double
	let ratingByn: Double
}

typealias Arcsongs = [Arcsong]

extension Arcsong {
	func constant(of difficulty: Difficulty) -> Double {
		switch difficulty {
			case .past:
				return Double(self.ratingPst)
			case .present:
				return Double(self.ratingPrs)
			case .future:
				return Double(self.ratingFtr)
			case .beyond:
				return Double(self.ratingByn)
		}
	}

	func playPtt(difficulty: Difficulty, score: Int) -> Double {
		let constant = constant(of: difficulty)

		if score >= 10_000_000 {
			return constant + 2
		} else if score >= 9_800_800 {
			return constant + 1 + Double(score - 9_800_000) / 200_000
		} else {
			return max(constant + Double(score - 9_500_000) / 300_000, 0)
		}
	}
}

extension Arcsongs {
	func getSong(sid: String) -> Arcsong? {
		return self.first { $0.sid == sid }
	}
}