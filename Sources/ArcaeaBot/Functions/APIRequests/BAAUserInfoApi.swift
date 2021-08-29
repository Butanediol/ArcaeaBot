import Foundation

func getUserBest(user: User, songname: String, difficulty: Difficulty, retry: Int = 5, completion: @escaping (Result<UserBest, APIError>) -> Void) {
    var urlParams = [
        "songname": songname,
        "difficulty": "\(difficulty.rawValue)",
    ]

    switch user {
    case let .userCode(userCode):
        urlParams["usercode"] = String(format: "%09d", userCode)
    case let .userName(userName):
        urlParams["user"] = userName
    }

    apiRequest(endpoint: "/user/best", urlParams: urlParams, retry: retry, completion: completion)
}

func getUserBest30(user: User, overflow: Int = 0, retry: Int = 9, completion: @escaping (Result<UserBest30, APIError>) -> Void) {
    var urlParams = [
        "overflow": "\(overflow)",
    ]

    switch user {
    case let .userCode(userCode):
        urlParams["usercode"] = String(format: "%09d", userCode)
    case let .userName(userName):
        urlParams["user"] = userName
    }

    apiRequest(endpoint: "/user/best30", urlParams: urlParams, retry: retry, completion: completion)
}

func getUserInfo(user: User, recent: Int = 0, retry: Int = 5, completion: @escaping (Result<UserInfo, APIError>) -> Void) {
    var urlParams = [
        "recent": "\(recent)",
    ]

    switch user {
    case let .userCode(userCode):
        urlParams["usercode"] = String(format: "%09d", userCode)
    case let .userName(userName):
        urlParams["user"] = userName
    }

    apiRequest(endpoint: "/user/info", urlParams: urlParams, retry: retry, completion: completion)
}
