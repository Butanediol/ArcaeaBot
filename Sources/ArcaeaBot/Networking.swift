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

	func request(endpoint: Endpoint, httpMethod: String, completion: @escaping (Result<RawResposne, Error>) -> Void) {
		var request = URLRequest(url: endpoint.url(baseUrl: baseUrl))
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

	func get<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
		request(endpoint: endpoint, httpMethod: "GET") { result in
			switch result {
				case .success(let rawResponse):
					do {
						let model = try JSONDecoder().decode(T.self, from: rawResponse)
						completion(.success(model))
					} catch {
						completion(.failure(error))
					}
				case .failure(let error):
					completion(.failure(error))
			}
		}
	}

	typealias RawResposne = Data

	enum Endpoint {
		case userInfo(ArcaeaFriendCode)
		case score(ArcaeaFriendCode)
		case best(ArcaeaFriendCode)

		var path: String {
			switch self {
				case .userInfo(let friend_code):
					return "/user/\(String(format: "%09d", friend_code))"
				case .score(let friend_code):
					return "/user/\(String(format: "%09d", friend_code))/score"
				case .best(let friend_code):
					return "/user/\(String(format: "%09d", friend_code))/best"
}
		}

		func url(baseUrl: URL) -> URL {
			let newUrl = baseUrl.appendingPathComponent(self.path)
			return newUrl
		}
	}
}