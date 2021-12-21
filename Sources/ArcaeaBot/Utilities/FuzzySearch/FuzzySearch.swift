extension ArcaeaBot {
    func fuzzySearchSong(searchText: String) -> String? {
        let fuse = Fuse()
        
        let song = arcSongAlias.keys.sorted { a, b in
            fuse.search(searchText, in: a)?.score ?? 1 < fuse.search(searchText, in: b)?.score ?? 1
            // let resultA = fuse.search(sid, in: a)
            // let resultB = fuse.search(sid, in: b)
            
            // let scoreA = resultA?.score ?? 1
            // let scoreB = resultB?.score ?? 1

            // let rangesA = resultA?.ranges
            // let rangesB = resultB?.ranges

            // if scoreA < scoreB { return true }
            // else if scoreA > scoreB { return false }
            // else {
            //  return rangesA?.count ?? 100 < rangesB?.count ?? 100
            // }
        }

        // let resultA = fuse.search(sid, in: "farawaylight")
        // let resultB = fuse.search(sid, in: "fractureray")

        // print(resultA?.score, resultA?.ranges)
        // print(resultB?.score, resultB?.ranges)

        return song.first
    }
}