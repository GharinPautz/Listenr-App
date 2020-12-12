//
//  Profile.swift
//  Listenr
//
//  Created by Gharin Pautz on 12/12/20.
//

import Foundation

class Profile {
    var favoriteArtist: String
    var favoriteTrack: String
    var favoriteGenres: [String]
    
    // Pull stored data from Firebase
    init() {
        favoriteArtist = "Troye Sivan"
        favoriteTrack = "Dance With Somebody"
        favoriteGenres = ["Pop", "Rap", "Rock"]
    }
}
