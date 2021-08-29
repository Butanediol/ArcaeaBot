import Foundation

func getSongInfo(search name: String, completion: @escaping (Result<SongInfo, APIError>) -> Void) {
    let urlParams = [
        "songname": name,
    ]

    apiRequest(endpoint: "/song/info", urlParams: urlParams, retry: 2, completion: completion)
}

func getRandomSong(from start: Int, to end: Int, completion: @escaping (Result<RandomSong, APIError>) -> Void) {
    let urlParams = [
        "start": "\(start)",
        "end": "\(end)",
    ]

    apiRequest(endpoint: "/song/random", urlParams: urlParams, retry: 2, completion: completion)
}
