//
//  NewSongViewController.swift
//  Listenr
//
//  Created by Colson, Kellie Anne on 11/27/20.
//

import UIKit

class NewSongViewController: UIViewController {

    @IBOutlet var albumArtImageView: UIImageView!
    @IBOutlet var trackTitleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    
    var artist: String? = nil
    var track: String? = nil

    var recommendedTrack: Track? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // STEPS TO TAKE
        // Call recommendationsAPI to get a recommended track and store the name, artist, and album art in the recommendedTrack optional
        // Update UI to show new recemmoneded track info
        // when user segues back to prevSongsVC, send the new information back and append to tracks array in prevSongsVC
        // reload data in prevSongsVC
    
        if let artistName = artist, let trackName = track{
            self.trackTitleLabel.text = trackName
            self.artistLabel.text = artistName
        }
        
        

            
    }
    

//    @IBAction func addToLibraryButtonPressed(_ sender: UIButton) {
//    }
        
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
