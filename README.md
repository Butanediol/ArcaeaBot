# ArcaeaBot

Telegram Arcaea 查分 Bot

## 使用

```
/my <Song> <byd/ftr/prs/pst> - 查询单曲最佳
/recent - 查询最近成绩
/best30 - 查询 Best 30
/me - 我是谁？
/bind <ArcID/ArcName> - 绑定 Arcaea 玩家账号

多人游戏
/multiplay - 随机选歌
/multiplay <Song> - 指定歌曲
/multiplay <Floor> <Ceiling> - 在 Floor 到 Ceiling 难度之间随机选歌
/multiplay <Floor> + 随机选择 Floor 或更难的歌曲
/multiplay <Ceiling> - 随机选择 Ceiling 或更简单的歌曲

注意：这里的难度是 Arcaea 游戏中的难度，例如 9, 9+, 10, 10+

/begin - 开始游戏，开始后新玩家不能加入。
/finish - 结束游戏，当你完成曲目后发送，当所有人都完成后会结束多人游戏。
/cancel - 取消当前的多人游戏。
```

## 构建

1. Clone 项目到本地

```sh
git clone https://github.com/Butanediol/ArcaeaBot
```

2. 在 ArcaeaBot/Sources/ArcaeaBot 中添加文件 `config.swift`，内容如下

```swift
// config.swift
import TelegramBotSDK

let token = readToken(from: "TELEGRAM_BOT_TOKEN")
let apiUrl = readToken(from: "BAA_URL")
let apiUAToken = readToken(from: "BAA_USER_AGENT")
```
这将从环境变量或同名文件读取配置字符串。

也可以改为固定值，例如：

```swift
// config.swift
import TelegramBotSDK

let token = "123456789:ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghi"
let apiUrl = "http://api.example.com/v4"
let apiUAToken = "myApiUAToken123456"
```

### macOS

1. 检查 swift 版本，开发版本为 5.4.2，5.0+ 应当能正常运行。

```sh
swift --version
```

2. 编译并运行

```sh
cd ArcaeaBot
swift build
swift run
```

### Linux

#### 自行编译

1. 根据 [Swift.org - Get Started](https://swift.org/getting-started/) 和 [Swift.org - Download](https://swift.org/download/) 下载并安装环境。

2. 编译并运行

```sh
git clone https://github.com/Butanediol/ArcaeaBot
cd ArcaeaBot
swift build
swift run
```

#### Docker

1. 自行安装 Docker

2. 修改 Dockerfile

若你使用从环境变量读取配置字符串，则需要在 Dockerfile 中，将变量 `TELEGRAM_BOT_TOKEN` `BAA_URL` 和 `BAA_USER_AGENT` 填写为实际的值。

3. 构建并运行

```sh
git clone https://github.com/Butanediol/ArcaeaBot
cd ArcaeaBot
docker build -t ArcaeaBot .
docker run --rm ArcaeaBot
```

## 开源相关

- [SwiftLMDB](https://github.com/agisboye/SwiftLMDB)
- [TelegramBotSDK](https://github.com/rapierorg/telegram-bot-swift)