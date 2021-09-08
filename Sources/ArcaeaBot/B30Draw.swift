import Foundation
import PythonKit

let sys = Python.import("sys")
let PIL = Python.import("PIL")
let Image = Python.import("PIL.Image")
let ImageFont = Python.import("PIL.ImageFont")
let ImageDraw = Python.import("PIL.ImageDraw")

let bgDarkUrl = Bundle.module.url(forResource: "bg_dark", withExtension: "jpg")!
let fontUrl = Bundle.module.url(forResource: "Exo-Regular", withExtension: "ttf")!

let image = Image.open(bgDarkUrl.path)
let smallFont = ImageFont.truetype(fontUrl.path, 10)
let mediumFont = ImageFont.truetype(fontUrl.path, 18)
let largeFont = ImageFont.truetype(fontUrl.path, 48)

struct PILColor {
    private let red: Int
    private let green: Int
    private let blue: Int
    private let alpha: Int

    init(_ r: Int, _ g: Int, _ b: Int, _ a: Int = 255) {
        red = r
        green = g
        blue = b
        alpha = a
    }

    var hex: String {
        let r = String(red, radix: 16)
        let g = String(green, radix: 16)
        let b = String(blue, radix: 16)
        let a = String(alpha, radix: 16)
        return "#" + r + g + b + a
    }

    var tuple: PythonObject {
        return PythonObject(tupleOf: red, green, blue, alpha)
    }

    static var random: PILColor {
        PILColor(Int.random(in: 0 ... 255), Int.random(in: 0 ... 255), Int.random(in: 0 ... 255), Int.random(in: 0 ... 255))
    }

    static let white = PILColor(255, 255, 255)
    static let black = PILColor(0, 0, 0)
}

struct B30Graph {
    private var b30: [UserPlay]

    init(b30: [UserPlay]) {
        self.b30 = b30
        if b30.count < 30 {
            for _ in 1 ... (30 - b30.count) {
                self.b30.append(.emptyPlay)
            }
        }
    }

    func draw() -> Data {
        print(sys.version)
        let draw = ImageDraw.Draw(image)

        for i in 1 ... 5 {
            for j in 1 ... 6 {
                let topLeftX = 103 + (i - 1) * 220
                let topLeftY = 73 + (j - 1) * 140
                let bottomRightX = topLeftX + 200
                let bottomRightY = topLeftY + 120

                let index = (j - 1) * 5 + i
                let play = b30[index - 1]
                let isPM = (play.score >= 10_000_000) ? true : false
                let isFR = (play.missCount == 0) ? true : false
                let length = max(10_000_000, play.score) * 200 / 10_000_000

                draw.rectangle([PythonObject(tupleOf: topLeftX, topLeftY), PythonObject(tupleOf: bottomRightX, bottomRightY)], PILColor.black.tuple)
                if isPM {
                    draw.rectangle([PythonObject(tupleOf: topLeftX, bottomRightY - 5), PythonObject(tupleOf: topLeftX + length, bottomRightY)], PILColor(71, 141, 255).tuple)
                } else if isFR {
                    draw.rectangle([PythonObject(tupleOf: topLeftX, bottomRightY - 5), PythonObject(tupleOf: topLeftX + length, bottomRightY)], PILColor(196, 255, 71).tuple)
                } else {
                    draw.rectangle([PythonObject(tupleOf: topLeftX, bottomRightY - 5), PythonObject(tupleOf: topLeftX + length, bottomRightY)], PILColor(255, 255, 255).tuple)
                }
                draw.text([topLeftX + 10, topLeftY + 10], "#\(String(format: "%02d", index))  " + play.songID.capitalized, "#ffffff", mediumFont)
                draw.text([topLeftX + 10, topLeftY + 68], "\(play.perfectCount)(+\(play.shinyPerfectCount))/\(play.nearCount)/\(play.missCount)  PTT: \(String(format: "%.2f", play.rating))", "#ffffff", smallFont)
                draw.text([topLeftX + 10, topLeftY + 81], "\(play.score)", "#ffffff", mediumFont)
            }
        }

        draw.text([970, 917], "Telegram@lowirosucksbot", "#ffffff", mediumFont)

        let savePath = URL(fileURLWithPath: "/tmp/\(UUID().uuidString).png")
        image.save(savePath.path)

        return (try? Data(contentsOf: savePath)) ?? Data()
    }
}
