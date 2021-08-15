// struct User: Codable {
// 	var usercode: Usercode
// 	var username: Username?

// 	init(usercode: Usercode) {
// 		self.usercode = usercode
// 	}
// }

enum User {
	case userCode(Usercode)
	case userName(Username)
}

typealias Usercode = Int
typealias Username = String
typealias TgUserId = Int64