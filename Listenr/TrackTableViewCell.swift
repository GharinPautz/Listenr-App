//
//  TrackTableViewCell.swift
//  Listenr
//
//  Created by Gharin Pautz on 12/12/20.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
    
    @IBOutlet var trackLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var albumArtImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(withTrack track: Track) {
        trackLabel.text = track.title
        artistLabel.text = track.artist
        // - TODO: have to update image view for cell
    }
}
