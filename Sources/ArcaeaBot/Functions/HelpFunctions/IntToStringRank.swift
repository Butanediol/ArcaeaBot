func intToStringRank(i: Int) -> String {
    switch i {
    case 1:
        return "🥇"
    case 2:
        return "🥈"
    case 3:
        return "🥉"
    default:
        return String(format: "%02d", i)
    }
}
