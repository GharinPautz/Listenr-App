//
//  PreviousSongsViewController.swift
//  Listenr
//
//  Created by Colson, Kellie Anne on 11/27/20.
//

import UIKit

class PreviousSongsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var artistID = ""
    var trackID = ""
    var tracks = [Track]()
    var profile = Profile()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeTracks()
        
        // call searchAPI for finding favorite artist's spotify ID
        // store artist ID in artistID property
        SpotifyAPI.fetchArtistID(artist: profile.favoriteArtist)
        // repeat this step for track
        // call fetchTrackID and store in trackID property
        
        // then when a row is selected... in the prepareFor method, send artistID, TrackID, and profile to NewSongViewController class
    }
    
    @IBAction func newSongButtonPressed(_ sender: UIButton) {
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
        let track1 = Track(title: "Easy", artist: "Troye Sivan", albumArtFileName: nil)
        let track2 = Track(title: "Dance With Somebody", artist: "Whitney Houston", albumArtFileName: nil)
        let track3 = Track(title: "The Trees", artist: "Goth Babe", albumArtFileName: nil)
        tracks.append(track1)
        tracks.append(track2)
        tracks.append(track3)
    }
}
