//
//  CreateAccountViewController.swift
//  Listenr
//  This is Ghar Pautz and Kellie Colson's final proejct for iOS App Development Fall, 2020. This program calls Spotify's Authentication, Search, and Recommendations APIs to produce songs for users based on their favorite tracks, artists, and genres of music. Additionally, the music data generated is stored using Firebase Firestore in the current user's account so they are able to access it again when they reopen the app after logging out.
//  CPSC 315-02, Fall 2020
//  Final Project
//
//  Created by Colson, Kellie Anne on 11/27/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateAccountViewController: UIViewController {
    //reference to Firesotre database
    let db = Firestore.firestore()

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var genresTextField: UITextField!
    @IBOutlet var favoriteSongTextField: UITextField!
    @IBOutlet var favoriteArtistTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
      Creates a new user account in Firebase using Firebase Authentication
      Adds user music preferences to Firebase Firestore database

      Parameter sender: reference to UIButton pressed by user to create their account
    */
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        // add plain music info entered by user to firebase

        if let email = emailTextField.text, let password = passwordTextField.text {
            if password.count >= 6 {
              // create user account in Firebase with email and password
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let resultError = error {
                    print(resultError)
                } else {
                    print("successfully registered new user")
                }
            }
                } else {
                    // notify user with an alert that their password must be at least 6 characters
                    let alertController = UIAlertController(title: "Password Too Short", message: "Your password must be at least 6 characters long", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alertController, animated: true, completion: nil)
                }
        }

        if let genres = genresTextField.text, let artist = favoriteArtistTextField.text, let song = favoriteSongTextField.text, let docID = emailTextField.text {
            var spotifyArtistID = ""
            var spotifyTrackID = ""

            // use artist name entered by user to find cooresponding Spotify artist ID using the Spotify Search API
            SpotifyAPI.fetchArtistID(artist: artist) { (artistIDOptional) in
                if let artistID = artistIDOptional {
                    spotifyArtistID = artistID
                    print("executing fetchArtistID completion closure")
                    // set returned Spotify artist ID in Firebase Firestore database
                    self.db.collection("users").document(docID).setData(["spotifyArtistID": spotifyArtistID], merge: true)
                } else {
                    print("artistIDOptional is nil")
                }

            }

            // use track name entered by user to find cooresponding Spotify track ID using the Spotify Search API
            SpotifyAPI.fetchTrackID(track: song) { (trackIDOptional) in
                if let trackID = trackIDOptional {
                    spotifyTrackID = trackID
                    print("executing fetchTrackID completion closure")
                    // set returned Spotify track ID in Firebase Firestore database
                    self.db.collection("users").document(docID).setData(["spotifyTrackID": spotifyTrackID], merge: true)
                } else {
                    print("trackIDOptional is nil")
                }
            }

            // add plaintext of user's favorite genres, favorite artist, and favorite song to Firebase Firestore database
            // create empty array for recommendedSongs in database
            db.collection("users").document(docID).setData(["genres": genres, "artist": artist, "song": song, "recommendedSongs": []], merge: true){
                err in
                if let err = err {
                    print("error adding document: \(err)")
                } else {
                    print("document added with ID: \(docID)")
                }
            }
        }


        // once user account has been created, pop view controller back to login view controller
        _ = navigationController?.popViewController(animated: true)
    }


}
