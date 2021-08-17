extension Array {
    func rankingWithTie(index: Int, by equation: (Element, Element) -> Bool) -> Int {
        var tiedNumber = 0
        if index == 0 { return 0 }
        for i in 1...index {
            if equation(self[index - i], self[index]) { tiedNumber += 1 }
        }
        return index - tiedNumber
    }
}

extension Array where Element: Equatable {
    func rankingWithTie(index: Int) -> Int {
        var tiedNumber = 0
        if index == 0 { return 0 }
        for i in 1...index {
            if self[index - i] == self[index] { tiedNumber += 1 }
        }
        return index - tiedNumber
    }
}