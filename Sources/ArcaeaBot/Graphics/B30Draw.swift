import Foundation
import PythonKit

let sys = Python.import("sys")
let PIL = Python.import("PIL")
let Image = Python.import("PIL.Image")
let ImageFont = Python.import("PIL.ImageFont")
let ImageDraw = Python.import("PIL.ImageDraw")

let bgDarkUrl = Bundle.module.url(forResource: "bg_dark", withExtension: "jpg")!
let fontUrl = Bundle.module.url(forResource: "Exo-Regular", withExtension: "ttf")!
let titleFontUrl = Bundle.module.url(forResource: "Kazesawa-Regular", withExtension: "ttf")!

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

struct Tuple: PythonConvertible {
    var pythonObject: PythonObject

    init(_ elements: PythonConvertible...) {
        pythonObject = PythonObject(tupleContentsOf: elements)
    }
}

struct B30Graph {
    private var b30: UserBest30
    private var b30play: [UserPlay]
    private var userInfo: UserInfo

    init(b30: UserBest30, userInfo: UserInfo) {
        self.b30 = b30
        b30play = b30.content.best30List
        if b30play.count < 30 {
            for _ in 1 ... (30 - b30play.count) {
                b30play.append(.emptyPlay)
            }
        }
        self.userInfo = userInfo
    }

    func draw() -> Data {
        var image = Image.open(bgDarkUrl.path).convert("RGBA")
        image = image.resize(Tuple(2572, 1930))
        let smallFont = ImageFont.truetype(fontUrl.path, 20)
        let mediumFont = ImageFont.truetype(fontUrl.path, 36)
        let titleFont = ImageFont.truetype(titleFontUrl.path, 36)

        let draw = ImageDraw.Draw(image)

        for i in 1 ... 5 {
            for j in 1 ... 6 {
                let topLeftX = 103 * 2 + (i - 1) * 220 * 2
                let topLeftY = 73 * 2 + (j - 1) * 140 * 2
                let bottomRightX = topLeftX + 200 * 2
                let bottomRightY = topLeftY + 120 * 2

                let index = (j - 1) * 5 + i
                let play = b30play[index - 1]
                let isPM = (play.score >= 10_000_000) ? true : false
                let isFR = (play.missCount == 0) ? true : false
                let length = max(10_000_000, play.score) * 200 / 10_000_000 * 2
                let diffColor: PILColor = {
                    switch play.difficulty {
                    case .past:
                        return PILColor(130, 223, 255)
                    case .present:
                        return PILColor(188, 255, 130)
                    case .future:
                        return PILColor(200, 130, 255)
                    case .beyond:
                        return PILColor(255, 130, 136)
                    }
                }()

                draw.rectangle([Tuple(topLeftX, topLeftY), Tuple(bottomRightX, bottomRightY)], PILColor.black.tuple)
                if isPM {
                    draw.rectangle([Tuple(topLeftX, bottomRightY - 5), Tuple(topLeftX + length, bottomRightY)], PILColor(71, 141, 255).tuple)
                } else if isFR {
                    draw.rectangle([Tuple(topLeftX, bottomRightY - 5), Tuple(topLeftX + length, bottomRightY)], PILColor(196, 255, 71).tuple)
                } else {
                    draw.rectangle([Tuple(topLeftX, bottomRightY - 5), Tuple(topLeftX + length, bottomRightY)], PILColor(255, 255, 255).tuple)
                }

                draw.text(Tuple(topLeftX + 10 * 2, topLeftY + 10 * 2), "#\(String(format: "%02d", index))", PILColor(255, 255, 255, 128).tuple, mediumFont)
                // draw.rectangle([Tuple(topLeftX + 10, topLeftY + 33), Tuple(topLeftX + 12, topLeftY + 47)], diffColor.tuple)
                // draw.text(Tuple(topLeftX + 15, topLeftY + 28), play.songID.capitalized, PILColor.white.tuple, mediumFont)
                draw.text(Tuple(topLeftX + 10 * 2, topLeftY + 28 * 2), songlist.safeGetSongTitle(id: play.songID).en, diffColor.tuple, mediumFont)
                draw.text(Tuple(topLeftX + 10 * 2, topLeftY + 68 * 2), "\(play.perfectCount)(+\(play.shinyPerfectCount))/\(play.nearCount)/\(play.missCount)  PTT: \(String(format: "%.2f", play.rating))", "#ffffff", smallFont)
                draw.text(Tuple(topLeftX + 10 * 2, topLeftY + 81 * 2), "\(play.score)", PILColor.white.tuple, mediumFont)
            }
        }

        draw.rectangle([Tuple(103 * 2, 917 * 2), Tuple(1183 * 2, 941 * 2)], PILColor.black.tuple)
        draw.text([103 * 2 + 2, 917 * 2], "B30 Avg. \(String(format: "%.3f", b30.content.best30Avg))", PILColor.white.tuple, mediumFont)
        draw.text([323 * 2 + 2, 917 * 2], "R10 Avg. \(String(format: "%.3f", b30.content.recent10Avg))", PILColor.white.tuple, mediumFont)
        draw.text([543 * 2 + 2, 917 * 2], "Player: \(userInfo.name)", PILColor.white.tuple, mediumFont)
        draw.text([763 * 2 + 2, 917 * 2], "PTT: \(String(format: "%.2f", b30.content.best30Avg * 0.75 + b30.content.recent10Avg * 0.25))", PILColor.white.tuple, mediumFont)
        draw.text([970 * 2 + 2, 917 * 2], "Telegram@lowirosucksbot", PILColor.white.tuple, mediumFont)

        let savePath = URL(fileURLWithPath: "/tmp/\(UUID().uuidString).png")
        image.save(savePath.path)

        return (try? Data(contentsOf: savePath)) ?? Data()
    }
}
