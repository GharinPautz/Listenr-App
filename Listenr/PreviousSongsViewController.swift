//
//  PreviousSongsViewController.swift
//  Listenr
//
//  Created by Colson, Kellie Anne on 11/27/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PreviousSongsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let db = Firestore.firestore()
    @IBOutlet var tableView: UITableView!
    
    var artistID = ""
    var trackID = ""
    var tracks = [Track]()
    var profile = Profile()
    
    override func viewDidLoad() {
        print("VIEW DID LOAD IN PREV SONGS")
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(PreviousSongsViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        tableView.delegate = self
        tableView.dataSource = self
        
        //loadTrackArray()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("VIEW DID APPEAR IN PREV SONGS")
        loadTrackArray()
        print(tracks)
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
        if let identifier = segue.identifier {
            if identifier == "newSongSegue"{
            
                if let newSongVC = segue.destination as? NewSongViewController {
                    newSongVC.profileOptional = profile
                }
            }
            else {
                if let detailVC = segue.destination as? DetailViewController {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        let track = tracks[indexPath.row]
                        detailVC.trackOptional = track                    
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
    
    func loadTrackArray() {
        var tracksArray = [Track]()
        
        let user = Auth.auth().currentUser?.email?.description ?? "username"
        db.collection("users").document(user).getDocument{ (document, error) in
            if let document = document, document.exists {
                 let jsonData = document.data() ?? nil
                 //print("document data: \(jsonData)")
                 // parse data
                if let jsonData = jsonData, let recommendedSongs = jsonData["recommendedSongs"] as? [[String: Any]] {
                     //print(recommendedSongs)
                    
                    for song in recommendedSongs {
                        let track = Track(title: song["songTitle"] as! String, artist: song["songArtist"] as! String, songLink: song["songLink"] as? String)
                        tracksArray.append(track)
                    }
                }
                
                self.tracks = tracksArray
                self.tableView.reloadData()
            }
        }
    }
    
}
