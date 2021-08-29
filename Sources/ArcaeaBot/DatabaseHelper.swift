import Foundation
import SwiftLMDB

var databaseEnvironment: Environment = {
    print("Initializing Database Environment...")

    let currentDirectoryPath = FileManager().currentDirectoryPath
    let envURL = URL(fileURLWithPath: currentDirectoryPath + "/db")

    // 文件夹必须已经存在。
    try! FileManager.default.createDirectory(at: envURL, withIntermediateDirectories: true, attributes: nil)

    let environment = try! Environment(path: envURL.path, flags: [], maxDBs: 32)

    return environment
}()

var userInfoDatabase: Database = {
    print("Initializing User Info Database ...")
    return try! databaseEnvironment.openDatabase(named: "arcaea", flags: [.create])
}()

var best30Database: Database = {
    print("Initializing Best 30 Database ...")
    return try! databaseEnvironment.openDatabase(named: "best30", flags: [.create])
}()

var multiplayDatabase: Database = {
    print("Initializing Multiplay Database ...")
    return try! databaseEnvironment.openDatabase(named: "multiplay", flags: [.create])
}()

func saveUserInfo(info: UserInfoResponse, tgUserId: TgUserId) {
    do {
        try userInfoDatabase.put(value: info, forKey: tgUserId)
    } catch {
        print("Save UserInfo error: \(error.localizedDescription)")
    }
}

func getUserInfoFromDatabase(tgUserId: TgUserId) -> UserInfoResponse? {
    do {
        return try userInfoDatabase.get(type: UserInfoResponse.self, forKey: tgUserId)
    } catch {
        print("Get UserInfoFromDatabase error: \(error.localizedDescription)")
    }
    return nil
}

func deleteUserInfoFromDatabase(tgUserId: TgUserId) {
    do {
        try userInfoDatabase.deleteValue(forKey: tgUserId)
    } catch {
        print("Delete UserInfoFromDatabase error: \(error.localizedDescription)")
    }
}

func saveBest30(b30: UserBest30, user: Usercode) {
    do {
        try best30Database.put(value: b30, forKey: user)
    } catch {
        print("Save Best30 error: \(error)")
    }
}

func getBest30FromDatabase(user: Usercode) -> UserBest30? {
    do {
        return try best30Database.get(type: UserBest30.self, forKey: user)
    } catch {
        print("Get Best30 from database error: \(error)")
    }
    return nil
}

func updateBest30FromRecent(_ recent: UserInfoResponse, user: Usercode) {
    guard let oldb30 = getBest30FromDatabase(user: user) else { return }
    guard let recentScore = recent.content.recentScore.first else { return }

    var newb30List = oldb30.content.best30List
    newb30List.append(recentScore)
    newb30List.sort {
        $0.rating > $1.rating
    }
    newb30List = newb30List.dropLast()
    let newb30Avg: Double = {
        var total: Double = 0
        for play in newb30List {
            total += play.rating
        }
        return total / 30
    }()
    let newr10Avg: Double = {
        40 * Double(recent.content.rating) - newb30Avg * 30
    }()
    let newb30 = UserBest30(
        status: oldb30.status,
        content: UserBest30Content(best30Avg: newb30Avg, recent10Avg: newr10Avg, best30List: newb30List, best30Overflow: nil)
    )
    saveBest30(b30: newb30, user: user)
}

func saveMultiplay(multiplay: Multiplay, room: Int64) {
    do {
        try multiplayDatabase.put(value: multiplay, forKey: room)
    } catch {
        print("Save Multiplay error: \(error)")
    }
}

func deleteMultiplay(room: Int64) {
    do {
        try multiplayDatabase.deleteValue(forKey: room)
    } catch {
        print("Delete Multiplay error: \(error)")
    }
}

func getMultiplayFromDatabase(room: Int64) -> Multiplay? {
    do {
        return try multiplayDatabase.get(type: Multiplay.self, forKey: room)
    } catch {
        print("Get Multiplay from database error: \(error)")
    }
    return nil
}

func joinMultiplay(room: Int64, tgUserId: TgUserId) -> Multiplay? {
    guard let oldMultiplay = getMultiplayFromDatabase(room: room) else { return nil }

    var newPlayers = oldMultiplay.players
    newPlayers.append(tgUserId)

    let newMultiplay = Multiplay(started: oldMultiplay.started, song: oldMultiplay.song, players: newPlayers)
    saveMultiplay(multiplay: newMultiplay, room: room)
    return newMultiplay
}

func getAllUserInfo() -> [(TgUserId, UserInfoResponse)] {
    var allUserInfo: [TgUserId: UserInfoResponse] = [:]
    for (key, value) in userInfoDatabase {
        let tgUserId = TgUserId(data: key)!
        let userInfo = UserInfoResponse(data: value)!
        allUserInfo[tgUserId] = userInfo
    }
    return allUserInfo.sorted {
        if $0.value.content.rating > $1.value.content.rating { return true }
        else if $0.value.content.name > $1.value.content.name { return true }
        else { return false }
    }
}
