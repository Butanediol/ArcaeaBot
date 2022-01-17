typealias SongId = String

struct SongInfoResponse: Codable, APIRequestResponsable {
    var status: Int
    var content: SongInfoResponseContent
}

struct SongInfoResponseContent: Codable {
    let id: String
    let titleLocalized: TitleLocalized
    let artist, bpm: String
    let bpmBase: Int
    let contentSet: String
    let worldUnlock, remoteDL: Bool
    let side, date: Int
    let version: String
    let difficulties: [SongInfoDifficulty]

    enum CodingKeys: String, CodingKey {
        case id
        case titleLocalized = "title_localized"
        case artist, bpm
        case bpmBase = "bpm_base"
        case contentSet = "set"
        case worldUnlock = "world_unlock"
        case remoteDL = "remote_dl"
        case side, date, version, difficulties
    }
}

struct SongInfoDifficulty: Codable {
    let ratingClass: Int
    let chartDesigner, jacketDesigner: String
    let jacketOverride: Bool
    let realrating: Int
}

struct TitleLocalized: Codable {
    let en: String
    let ja: String?
}