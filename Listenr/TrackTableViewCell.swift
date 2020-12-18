//
//  TrackTableViewCell.swift
//  Listenr
//  This is Ghar Pautz and Kellie Colson's final proejct for iOS App Development Fall, 2020. This program calls Spotify's Authentication, Search, and Recommendations APIs to produce songs for users based on their favorite tracks, artists, and genres of music. Additionally, the music data generated is stored using Firebase Firestore in the current user's account so they are able to access it again when they reopen the app after logging out.
//  CPSC 315-02, Fall 2020
//  Final Project
//
//  Created by Gharin Pautz on 12/12/20.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
    
    @IBOutlet var trackLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /**
     Updates a cell's contents with the relevant information of a Track
     */
    func update(withTrack track: Track) {
        trackLabel.text = track.title
        artistLabel.text = track.artist
    }
}
