//
//  Track.swift
//  Listenr
//  This is Ghar Pautz and Kellie Colson's final proejct for iOS App Development Fall, 2020. This program calls Spotify's Authentication, Search, and Recommendations APIs to produce songs for users based on their favorite tracks, artists, and genres of music. Additionally, the music data generated is stored using Firebase Firestore in the current user's account so they are able to access it again when they reopen the app after logging out.
//  CPSC 315-02, Fall 2020
//  Final Project
//
//  Created by Gharin Pautz on 12/12/20.
//

import Foundation

/**
 Custom class that models the state of a Track.
 */
class Track {
    var title: String
    var artist: String
    var songLink: String?
    
    /**
     Initializes all values in Track object
     
     - Parameters:
        - title: The title of the track
        - artist: The artist that made the track
        - songLink: The link to play a track from Spotify's API
     */
    init(title: String, artist: String, songLink: String?) {
        self.title = title
        self.artist = artist
        self.songLink = songLink
    }
}
