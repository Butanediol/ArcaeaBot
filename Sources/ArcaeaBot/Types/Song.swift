typealias SongId = String

struct SongInfoResponse: Codable, APIRequestResponsable {
    var status: Int
    var content: SongInfo
}

// MARK: - Content

struct SongInfo: Codable {
    let id: SongId
    let titleLocalized: TitleLocalized
    let artist, bpm: String
    let bpmBase: Double
    let contentSet: String
    let audioTimeSEC, side: Int
    let remoteDL, worldUnlock: Bool
    let date: Int
    let version: String
    let difficulties: [SongInfoDifficulty]

    enum CodingKeys: String, CodingKey {
        case id
        case titleLocalized = "title_localized"
        case artist, bpm
        case bpmBase = "bpm_base"
        case contentSet = "set"
        case audioTimeSEC = "audioTimeSec"
        case side
        case remoteDL = "remote_dl"
        case worldUnlock = "world_unlock"
        case date, version, difficulties
    }
}

// MARK: - Difficulty

struct SongInfoDifficulty: Codable {
    let ratingClass: Int
    let chartDesigner, jacketDesigner: String
    let rating: Int
    let ratingReal: Double
    let totalNotes: Int
    let ratingPlus: Bool?
}

// MARK: - TitleLocalized

struct TitleLocalized: Codable {
    let en: String
    let ja: String?
}
