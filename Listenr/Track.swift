//
//  Track.swift
//  Listenr
//
//  Created by Gharin Pautz on 12/12/20.
//

import Foundation

class Track {
    var title: String
    var artist: String
    var albumArtFileName: String?
    
    init(title: String, artist: String, albumArtFileName: String?) {
        self.title = title
        self.artist = artist
        self.albumArtFileName = albumArtFileName
    }
}
