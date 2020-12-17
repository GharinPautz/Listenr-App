//
//  Profile.swift
//  Listenr
//
//  Created by Gharin Pautz on 12/12/20.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class Profile {
    // reference to Firestore database
    let db = Firestore.firestore()


    var favoriteArtist: String = ""
    var favoriteTrack: String = ""
    var favoriteGenres: [String] = []
    var favoriteArtistSpotifyID: String = ""
    var favoriteTrackSpotifyID: String = ""

    /*
      Initialize profile object by pulling stored user information from Firebase Authentication and Firestore database
    */
    init() {
        // check there is a currently logged in user
        if Auth.auth().currentUser != nil {
            // get reference to user from Firebase Authentication
            let user = Auth.auth().currentUser?.email?.description ?? "username"

            // get data about user from the Firestore database
            // user account email is the identifier for the document on that user in the database
            db.collection("users").document(user).getDocument {(document,error) in
                if let document = document, document.exists {
                    let jsonData = document.data() ?? nil
                    print("document data: \(jsonData)")
                    // parse data from database
                    if let jsonData = jsonData, let favArtist = jsonData["artist"] as? String, let favSong = jsonData["song"] as? String, let favGenres = jsonData["genres"] as? String, let favGenresArray = favGenres.components(separatedBy: ", ") as? [String], let artistID = jsonData["spotifyArtistID"] as? String, let trackID = jsonData["spotifyTrackID"] as? String {
                        self.favoriteArtist = favArtist
                        self.favoriteTrack = favSong
                        self.favoriteGenres = favGenresArray
                        self.favoriteArtistSpotifyID = artistID
                        self.favoriteTrackSpotifyID = trackID
                    }
                } else {
                    print("document does not exist")
                }
            }
        } else {
            print("no user signed in")
        }
    }
}
