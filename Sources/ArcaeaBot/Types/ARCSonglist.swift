import Foundation

struct ARCSonglist: Codable {
    let songs: [ARCSong]

    static let shared: ARCSonglist = {
        let url = Bundle.module.url(forResource: "songlist", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let songlist = try! JSONDecoder().decode(ARCSonglist.self, from: data)
        return songlist
    }()
}

struct ARCSong: Codable {
    let id: String
    let titleLocalized: TitleLocalized

    enum CodingKeys: String, CodingKey {
        case id
        case titleLocalized = "title_localized"
    }
}

extension ARCSong {
    struct TitleLocalized: Codable {
        let en: String
        let ko, zhHant, zhHans, ja: String?
        let kr: String?

        enum CodingKeys: String, CodingKey {
            case en, ko
            case zhHant = "zh-Hant"
            case zhHans = "zh-Hans"
            case ja, kr
        }

        init(id: String) {
            self.en = id
            self.ko = nil
            self.zhHans = nil
            self.zhHant = nil
            self.ja = nil
            self.kr = nil
        }
    }
}

extension ARCSonglist {
    private func getSongTitle(id: String) -> ARCSong.TitleLocalized? {
        for song in songs {
            if song.id == id {
                return song.titleLocalized
            }
        }
        return nil
    }

    func safeGetSongTitle(id: String) -> ARCSong.TitleLocalized {
        return getSongTitle(id: id) ?? ARCSong.TitleLocalized(id: id)
    }
}


