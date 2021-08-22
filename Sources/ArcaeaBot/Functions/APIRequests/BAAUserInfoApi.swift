import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func getUserBest(user: User, songname: String, difficulty: Difficulty, retry: Int = 5, completion: @escaping (Result<UserBest, APIError>) -> Void) {

    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

    guard var URL = URL(string: apiUrl + "/user/best") else {return}

    var URLParams = [
        "songname": songname,
        "difficulty": "\(difficulty.rawValue)",
    ]

    switch user {
    	case .userCode(let userCode):
    		URLParams["usercode"] = String(format: "%09d", userCode)
    	case .userName(let userName):
    		URLParams["user"] = userName
    }

    URL = URL.appendingQueryParameters(URLParams)
    var request = URLRequest(url: URL)
    request.httpMethod = "GET"

    // Headers

    request.addValue(apiUAToken, forHTTPHeaderField: "User-Agent")

    /* Start a new Task */
    let task = session.dataTask(with: request) { data, response, error -> Void in

    	guard let data = data else {
    		print("URL Session Task Failed:", error!.localizedDescription)
            if retry > 0 { sleep(1); getUserBest(user: user, songname: songname, difficulty: difficulty, retry: retry - 1, completion: completion) }
            else { completion(.failure(APIError.networkError)) }
    		return
    	}

    	guard let userBest = try? JSONDecoder().decode(UserBest.self, from: data) else {
    		print("\(String(data: data, encoding: .utf8) ?? "")")
            if let apiError = try? JSONDecoder().decode(APIError.self, from: data) { completion(.failure(apiError)) } 
            else if retry > 0 { sleep(1); getUserBest(user: user, songname: songname, difficulty: difficulty, retry: retry - 1, completion: completion) }
            else { completion(.failure(.decodingError)) }
    		return
    	}

        completion(.success(userBest))
        
    }
    task.resume()
    session.finishTasksAndInvalidate()
}

func getUserBest30(user: User, overflow: Int = 0, retry: Int = 9, completion: @escaping (Result<UserBest30, APIError>) -> Void) {

    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

    guard var URL = URL(string: apiUrl + "/user/best30") else {return}
    var URLParams = [
        "overflow": "\(overflow)",
    ]

    switch user {
    	case .userCode(let userCode):
    		URLParams["usercode"] = String(format: "%09d", userCode)
    	case .userName(let userName):
    		URLParams["user"] = userName
    }

    URL = URL.appendingQueryParameters(URLParams)
    var request = URLRequest(url: URL)
    request.httpMethod = "GET"

    request.addValue(apiUAToken, forHTTPHeaderField: "User-Agent")

    /* Start a new Task */
    let task = session.dataTask(with: request) { data, response, error in
        guard let data = data else {
            // Failed
        	print("URL Session Task Failed :", error!.localizedDescription, " retry: ", retry)
            if retry > 0 { sleep(1); getUserBest30(user: user, retry: retry - 1, completion: completion) }
            else { completion(.failure(.networkError)) }
        	return
        }

        guard let userBest30 = try? JSONDecoder().decode(UserBest30.self, from: data) else {
    		print("\(String(data: data, encoding: .utf8) ?? "")")
            if let apiError = try? JSONDecoder().decode(APIError.self, from: data) { completion(.failure(apiError)) }
            else if retry > 0 { sleep(1); getUserBest30(user: user, retry: retry - 1, completion: completion) }
            else { completion(.failure(.decodingError)) }
    		return
    	}

        completion(.success(userBest30))
    }
    task.resume()
    session.finishTasksAndInvalidate()
}


func getUserInfo(user: User, recent: Int = 0, retry: Int = 5, completion: @escaping (Result<UserInfo, APIError>) -> Void) {

    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

    guard var URL = URL(string: apiUrl + "/user/info") else {return}
    var URLParams = [
        "recent": "\(recent)",
    ]

    switch user {
    	case .userCode(let userCode):
    		URLParams["usercode"] = String(format: "%09d", userCode)
    	case .userName(let userName):
    		URLParams["user"] = userName
    }

    URL = URL.appendingQueryParameters(URLParams)
    var request = URLRequest(url: URL)
    request.httpMethod = "GET"

    request.addValue(apiUAToken, forHTTPHeaderField: "User-Agent")

    let task = session.dataTask(with: request) { data, response, error in
	    guard let data = data else {
	    	print("URL Session Task Failed: %@", error!.localizedDescription)
            if retry > 0 { sleep(1); getUserInfo(user: user, recent: recent, retry: retry - 1, completion: completion) }
            else { completion(.failure(.networkError)) }
	    	return
	    }

	    guard let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data) else {
			print("UserInfo decoding error, content: \(String(data: data, encoding: .utf8) ?? "")")
            if let apiError = try? JSONDecoder().decode(APIError.self, from: data) { completion(.failure(apiError))}
            else if retry > 0 { sleep(1); getUserInfo(user: user, recent: recent, retry: retry - 1, completion: completion) }
            else { completion(.failure(.decodingError)) }
			return
		}

	    completion(.success(userInfo))
    }
    task.resume()
    session.finishTasksAndInvalidate()
}