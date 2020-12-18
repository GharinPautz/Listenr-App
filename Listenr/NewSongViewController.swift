//
//  NewSongViewController.swift
//  Listenr
//
//  This is Ghar Pautz and Kellie Colson's final proejct for iOS App Development Fall, 2020. This program calls Spotify's Authentication, Search, and Recommendations APIs to produce songs for users based on their favorite tracks, artists, and genres of music. Additionally, the music data generated is stored using Firebase Firestore in the current user's account so they are able to access it again when they reopen the app after logging out.
//  CPSC 315-02, Fall 2020
//  Final Project
//
//  Created by Colson, Kellie Anne on 11/27/20.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

/**
 View Controller in charge of events fired on screen that generates new songs from Spotify Recommendations API
 */
class NewSongViewController: UIViewController {
    let db = Firestore.firestore()
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var trackTitleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    
    var profileOptional: Profile? = nil

    var recommendedTrack: Track? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // STEPS TO TAKE
        // Call recommendationsAPI to get a recommended track and store the name, artist, and album art in the recommendedTrack optional
        // Update UI to show new recemmoneded track info
        // when user segues back to prevSongsVC, send the new information back and append to tracks array in prevSongsVC
        // reload data in prevSongsVC
    
        print("IN NEW SONG VC")
        
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.imageEdgeInsets = UIEdgeInsets(top: 200, left: 200, bottom: 200, right: 200)
        
        
        if let profile = profileOptional {
            print("NEW SONG VC: \(profile.favoriteTrackSpotifyID)")
            print("NEW SONG VC: \(profile.favoriteArtistSpotifyID)")
            
            SpotifyAPI.getSongRecommendation(artistID: profile.favoriteArtistSpotifyID, trackID: profile.favoriteTrackSpotifyID, genres: profile.favoriteGenres) { (recommendedTrack) in
                if let track = recommendedTrack {
                    self.recommendedTrack = track
                    let artist = track.artist
                    let song = track.title
                    let link = track.songLink
                    
                    print("Artist in prepare: \(artist)")
                    print("Song in prepare: \(song)")

                    self.trackTitleLabel.text = song
                    self.artistLabel.text = artist
                     
                }
            }
        }
    }
    
    /**
     Link opened and redirected to safari when play button is pressed
     
     - Parameters: sender is the UIButton object that is pressed
     */
    @IBAction func playButtonPressed(sender: UIButton){
        if let link = recommendedTrack?.songLink {
            UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
        } else {
            let alertController = UIAlertController(title: "No Preview Available", message: "This song does not have a preview available", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        }
    }
    

    /**
     Adds new track from recommendations API to user's song library
     
     - Parameters: sender is the UIButton that is pressed in storyboard
     */
    @IBAction func addToLibraryButtonPressed(_ sender: UIButton) {
        print("IN ADD TO LIBRARY BUTTON PRESSED")
        let user = Auth.auth().currentUser?.email?.description ?? "username"
        if let trackTitle = recommendedTrack?.title, let artistName = recommendedTrack?.artist {
            if let songLink = recommendedTrack?.songLink {
                print("IN IF WHEN LIBRARY BUTTON PRESSED")
                let data: [String: Any] = [
                    "songTitle": trackTitle,
                    "songArtist": artistName,
                    "songLink": songLink
                ]
                
                self.db.collection("users").document(user).updateData(["recommendedSongs": FieldValue.arrayUnion([data])])
                
            } else {
                print("IN ELSE AFTER LIBRARY BUTTON PRESSED")
                let data: [String: Any?] = [
                    "songTitle": trackTitle,
                    "songArtist": artistName,
                    "songLink": nil
                ]
                //self.db.collection("users").document(user).setData(data, merge: true)
                self.db.collection("users").document(user).updateData(["recommendedSongs": FieldValue.arrayUnion([data])])
            }
            
            //if let prevSongVC = 
        } else {
            print("IN ELSE, FAILED FIRST IF STATMENT TO GET SONG AND ARTIST")
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
        
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
