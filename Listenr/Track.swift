//
//  Track.swift
//  Listenr
//
//  Created by Gharin Pautz on 12/12/20.
//

import Foundation

class Track: CustomStringConvertible {
    var title: String
    var artist: String
    var songLink: String?
    var description: String {
        var str = "Track: \(title), \(artist), \(songLink)"
        return str
    }
    
    init(title: String, artist: String, songLink: String?) {
        self.title = title
        self.artist = artist
        self.songLink = songLink
    }
}
