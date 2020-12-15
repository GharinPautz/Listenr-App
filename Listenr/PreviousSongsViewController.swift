//
//  PreviousSongsViewController.swift
//  Listenr
//
//  Created by Colson, Kellie Anne on 11/27/20.
//

import UIKit
import FirebaseAuth

class PreviousSongsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var artistID = ""
    var trackID = ""
    var tracks = [Track]()
    var profile = Profile()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(PreviousSongsViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        tableView.delegate = self
        tableView.dataSource = self
        
        //initializeTracks()
        
        
        

    }
    
    @objc func back(sender: UIBarButtonItem ) {
        // return to sign in view controller
        _ = navigationController?.popViewController(animated: true)
        // logout
        do {
            try Auth.auth().signOut()
            print("successfully logged out user")
        } catch let error as NSError{
            print("error signing out \(error)")
        }
        
    }
    
    @IBAction func newSongButtonPressed(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newSongSegue"{
            if let newSongVC = segue.destination as? NewSongViewController {
                SpotifyAPI.getSongRecommendation(artistID: profile.favoriteArtistSpotifyID, trackID: profile.favoriteTrackSpotifyID, genres: profile.favoriteGenres) { (recommendedTrack) in
                    if let track = recommendedTrack {
                        let artist = track.artist
                        let song = track.title
                        
                        print("Artist in prepare: \(artist)")
                        print("Song in prepare: \(song)")
                        
                        newSongVC.artist = artist
                        newSongVC.track = song
                    }
                }
            }

        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tracks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let track = tracks[row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackTableViewCell
        
        cell.update(withTrack: track)
        return cell
    }
    
    func initializeTracks() {
        let track1 = Track(title: "Easy", artist: "Troye Sivan")
        let track2 = Track(title: "Dance With Somebody", artist: "Whitney Houston")
        let track3 = Track(title: "The Trees", artist: "Goth Babe")
        tracks.append(track1)
        tracks.append(track2)
        tracks.append(track3)
    }
}
