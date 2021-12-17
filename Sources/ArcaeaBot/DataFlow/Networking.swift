import Foundation
import Logging

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct ArcaeaLimitedApi {
	let token: String
	let baseUrl: URL
	let session: URLSession
	let logger: Logger

	init(token: String, logger: Logger) {
		self.token = token
		self.baseUrl = URL(string: "https://arcaea-limitedapi.lowiro.com/api/v0")!
		self.logger = logger

		let config = URLSessionConfiguration.default
		self.session = URLSession(configuration: config)
	}

	func request(endpoint: Endpoint, httpMethod: String, paramaters: [String: String] = [:], completion: @escaping (Result<RawResposne, Error>) -> Void) {
		let url = endpoint.url(baseUrl: baseUrl)
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod

		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")

		session.dataTask(with: request) { data, response, error in 
			if let data = data {
				completion(.success(data))
			}

			// if let response = response {
			// 	logger.info("\(response): \(String(format: endpoint.path))")
			// }

			if let error = error {
				completion(.failure(error))
			}
		}.resume()
	}

	func get<T: Codable>(endpoint: Endpoint, paramaters: [String: String] = [:], completion: @escaping (Result<T, Error>) -> Void) {
		request(endpoint: endpoint, httpMethod: "GET", paramaters: paramaters) { result in
			switch result {
				case .success(let rawResponse):
					do {
						let model = try JSONDecoder().decode(T.self, from: rawResponse)
						completion(.success(model))
					} catch {
						let apiError = try? JSONDecoder().decode(APIError.self, from: rawResponse)
						logger.error("\(String(data: rawResponse, encoding: .utf8)!)")
						completion(.failure(apiError ?? error))
					}
				case .failure(let error):
					completion(.failure(error))
			}
		}
	}

	typealias RawResposne = Data

	enum Endpoint {
		case userInfo(ArcaeaFriendCode)
		case score(Difficulty, ArcaeaFriendCode, String)
		case best(ArcaeaFriendCode)

		var path: String {
			switch self {
				case .userInfo(let friend_code):
					return "/user/\(String(format: "%09d", friend_code))"
				case .score(_, let friend_code, _):
					return "/user/\(String(format: "%09d", friend_code))/score"
				case .best(let friend_code):
					return "/user/\(String(format: "%09d", friend_code))/best"
}
		}

		func url(baseUrl: URL) -> URL {
			let newUrl = baseUrl.appendingPathComponent(self.path)
			switch self {
				case .score(let difficulty, _, let songId):
					return newUrl.appendingQueryParameters([ "difficulty": "\(difficulty.rawValue)", "song_id": songId])
				default:
					return newUrl
			}
		}
	}
}

struct APIError: LocalizedError, Codable {
	let message: String

	var errorDescription: String? {
		self.message
	}
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
    */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
    */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}
