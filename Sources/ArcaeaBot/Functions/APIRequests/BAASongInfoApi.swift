import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

internal let sessionConfig = URLSessionConfiguration.default

func getSongInfo(search name: String, completion: @escaping (Result<SongInfo, APIError>) -> Void) {

    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

    guard var URL = URL(string: apiUrl + "/song/info") else {return}
    let URLParams = [
        "songname": name,
    ]
    URL = URL.appendingQueryParameters(URLParams)
    var request = URLRequest(url: URL)
    request.httpMethod = "GET"

    // Headers

    request.addValue(apiUAToken, forHTTPHeaderField: "User-Agent")

    /* Start a new Task */
    let task = session.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("URL Session Task Failed: %@", error!.localizedDescription)
            completion(.failure(.networkError))
            return
        }

        guard let songInfo = try? JSONDecoder().decode(SongInfo.self, from: data) else {
            print("UserInfo decoding error, content: \(String(data: data, encoding: .utf8) ?? "")")
            let apiError = try? JSONDecoder().decode(APIError.self, from: data)
            completion(.failure(apiError ?? .decodingError))
            return
        }

        completion(.success(songInfo))
    }
    task.resume()
    session.finishTasksAndInvalidate()
}

func getRandomSong(from start: Int, to end: Int, completion: @escaping (Result<RandomSong, APIError>) -> Void) {

    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

    guard var URL = URL(string: apiUrl + "/song/random") else {return}
    let URLParams = [
        "start": "\(start)",
        "end": "\(end)"
    ]
    URL = URL.appendingQueryParameters(URLParams)
    var request = URLRequest(url: URL)
    request.httpMethod = "GET"

    // Headers

    request.addValue(apiUAToken, forHTTPHeaderField: "User-Agent")

    /* Start a new Task */
    let task = session.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("URL Session Task Failed: %@", error!.localizedDescription)
            completion(.failure(.networkError))
            return
        }

        guard let randomSong = try? JSONDecoder().decode(RandomSong.self, from: data) else {
            print("UserInfo decoding error, content: \(String(data: data, encoding: .utf8) ?? "")")
            let apiError = try? JSONDecoder().decode(APIError.self, from: data)
            completion(.failure(apiError ?? .decodingError))
            return
        }

        completion(.success(randomSong))
    }
    task.resume()
    session.finishTasksAndInvalidate()
}