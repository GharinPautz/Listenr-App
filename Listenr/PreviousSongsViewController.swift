//
//  PreviousSongsViewController.swift
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

class PreviousSongsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let db = Firestore.firestore()
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
        
        //loadTrackArray()
    }
    
    /**
     Calls for the data source of the table view to be reloaded after the current user's data is pulled from Firebase
     
     - Parameters: animated
     */
    override func viewDidAppear(_ animated: Bool) {
        loadTrackArray()
        print(tracks)
    }
    
    /**
     Action that is executed when back button is pressed in navigation controller, which entails signing out of the current user's account on Firebase.
     
     - Parameters: sender is the UIBarButtonItem in the view controller that was pressed
     */
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
    
    /**
     Method to prepare for segue from PreviousSongsViewController
     
     - Parameters:
        - segue: The segue being performed
        - sender: The event that triggered the segue
     */
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

    /**
    Method for UITableViewDelegate protocol
    
    - Parameters:
        - tableView: the table view object
        - numberOfRowsInSection: the number of rows
    - Returns: An integer representing the number of cells in table
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tracks.count
        }
        return 0
    }
    
    /**
    Method for UITableViewDelegate protocol. Updates the cell's information with a Place object.
    
    - Parameters:
       - tableView: the table view object
       - indexPath: the selected row
    - Returns: A  cell in the table
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let track = tracks[row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackTableViewCell
        
        cell.update(withTrack: track)
        return cell
    }
    
    /**
     Loading the Track data from Firebase to the data soure array for the table view
     */
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
