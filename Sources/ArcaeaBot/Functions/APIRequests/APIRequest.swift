import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

internal let sessionConfig: URLSessionConfiguration = {
    let config = URLSessionConfiguration.ephemeral
    config.httpMaximumConnectionsPerHost = 1
    config.timeoutIntervalForRequest = 60
    config.timeoutIntervalForResource = 120
    return config
}()

func apiRequest<T: APIRequestResponsable>(endpoint: String, urlParams: [String: String], httpMethod: String = "GET", retry: Int, completion: @escaping (Result<T, APIError>) -> Void) {
    print("endpoint: \(endpoint)")
    requestCount += 1
    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

    guard var url = URL(string: apiUrl + endpoint) else { return }

    url = url.appendingQueryParameters(urlParams)
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod

    // Headers

    request.addValue(apiUAToken, forHTTPHeaderField: "User-Agent")

    /* Start a new Task */
    let task = session.dataTask(with: request) { data, _, error -> Void in

        guard let data = data else {
            errorRequestCount += 1
            print("URL Session Task Failed:", error!.localizedDescription)
            if retry > 0 { sleep(3); apiRequest(endpoint: endpoint, urlParams: urlParams, retry: retry - 1, completion: completion) }
            else { completion(.failure(APIError.networkError)) }
            return
        }

        guard let returning = try? JSONDecoder().decode(T.self, from: data) else {
            print("\(String(data: data, encoding: .utf8) ?? "")")
            if let apiError = try? JSONDecoder().decode(APIError.self, from: data) { completion(.failure(apiError)) }
            else if retry > 0 { errorRequestCount += 1; sleep(3); apiRequest(endpoint: endpoint, urlParams: urlParams, retry: retry - 1, completion: completion) }
            else { errorRequestCount += 1; completion(.failure(.decodingError)) }
            return
        }

        completion(.success(returning))
    }
    task.resume()
    session.finishTasksAndInvalidate()
}
