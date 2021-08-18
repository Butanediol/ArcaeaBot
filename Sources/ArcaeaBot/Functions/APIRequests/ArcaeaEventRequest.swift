import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func getArcaeaEvent(retry: Int = 9, completion: @escaping (Result<[ArcaeaEvent], APIError>) -> Void) {
	let url = URL(string: "https://warehouse.butanediol.me/Miscellaneous/Extras/arcaea_events.json?raw&proxied")!
    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
	let task = session.dataTask(with: url) { data, response, error in 
		guard let data = data else {
			print("URL Session Task Failed:", error!.localizedDescription)
			if retry > 0 { getArcaeaEvent(retry: retry - 1, completion: completion) }
			else { completion(.failure(APIError.networkError)) }
    		return
		}

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		guard let events = try? decoder.decode([ArcaeaEvent].self, from: data) else {
			print("\(String(data: data, encoding: .utf8) ?? "")")
			if retry > 0 {
				getArcaeaEvent(retry: retry - 1, completion: completion)
			} else {
				let apiError = try? decoder.decode(APIError.self, from: data)
		        completion(.failure(apiError ?? .decodingError))
			}
			
            return
		}

		completion(.success(events))
	}
	task.resume()
}