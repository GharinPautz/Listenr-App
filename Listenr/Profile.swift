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
    let db = Firestore.firestore()

    
    var favoriteArtist: String = ""
    var favoriteTrack: String = ""
    var favoriteGenres: [String] = []
    
    // Pull stored data from Firebase
    init() {
        
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser?.email?.description ?? "username"
            db.collection("users").document(user).getDocument {(document,error) in
                if let document = document, document.exists {
                    let jsonData = document.data() ?? nil
                    print("document data: \(jsonData)")
                    // parse data
                    if let jsonData = jsonData, let favArtist = jsonData["artist"] as? String, let favSong = jsonData["song"] as? String, let favGenres = jsonData["genres"] as? String, let favGenresArray = favGenres.components(separatedBy: ", ") as? [String]{
                        self.favoriteArtist = favArtist
                        self.favoriteTrack = favSong
                        self.favoriteGenres = favGenresArray

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
