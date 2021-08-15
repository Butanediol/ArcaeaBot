extension Int {
	func isValidArcId() -> Bool {
		if self > 999999999 {
			return false 
		} else {
			return true
		}
	}
}