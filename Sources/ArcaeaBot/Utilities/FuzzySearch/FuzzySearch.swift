extension ArcaeaBot {
    func fuzzySearchSong(searchText: String) -> String? {
        let fuse = Fuse()

        if let song = arcSong.first(where: { song in
            // Full match of song name or song id, case insensitive
            song.sid == searchText || song.nameEn.lowercased().replacingOccurrences(of: " ", with: "") == searchText.replacingOccurrences(of: " ", with: "").lowercased()
        }) {
            ArcaeaBot.logger.info("\(searchText) matches song name \(song.nameEn) or song id \(song.sid)")
            return song.sid
        }

        for (sid, aliases) in arcSongAlias {
            // Full match of song alias
            for alias in aliases.map({ $0.lowercased() }) {
                if alias.contains(searchText.lowercased()) { 
                    ArcaeaBot.logger.info("\(searchText) matches song alias \(alias)")
                    return sid 
                }
            }
        }
        
        let song = arcSongAlias.keys.sorted { a, b in
            // song id fuzzy search
            fuse.search(searchText, in: a)?.score ?? 1 < fuse.search(searchText, in: b)?.score ?? 1
        }

        ArcaeaBot.logger.info("\(searchText) matches songid fuzzy search \(song.first ?? "nil")")
        return song.first
    }

    func fuzzySearchPack(searchText: String) -> String? {
        let fuse = Fuse()
        let pack = Set(arcSong.map {$0.packSet.lowercased()})
        let packSimilarityRank = pack.sorted { pack1, pack2 in
            fuse.search(searchText, in: pack1)?.score ?? 1 < fuse.search(searchText, in: pack2)?.score ?? 1
        }
        return packSimilarityRank.first
    }
}