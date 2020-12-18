//
//  DetailViewController.swift
//  Listenr
//  This is Ghar Pautz and Kellie Colson's final proejct for iOS App Development Fall, 2020. This program calls Spotify's Authentication, Search, and Recommendations APIs to produce songs for users based on their favorite tracks, artists, and genres of music. Additionally, the music data generated is stored using Firebase Firestore in the current user's account so they are able to access it again when they reopen the app after logging out.
//  CPSC 315-02, Fall 2020
//  Final Project
//
//  Created by Gharin Pautz on 12/17/20.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var songTitleLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    
    var trackOptional: Track? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playButton.imageView?.contentMode = .scaleAspectFit
        playButton.imageEdgeInsets = UIEdgeInsets(top: 200, left: 200, bottom: 200, right: 200)
        updateUI()
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
     Updates the UILabels' texts with updated Track's information
     */
    func updateUI() {
        if let track = trackOptional {
            songTitleLabel.text = track.title
            artistLabel.text = track.artist
        }
    }
    
    /**
     Link opened and redirected to safari when play button is pressed
     
     - Parameters: sender is the UIButton object that is pressed
     */
    @IBAction func playButtonPressed(sender: UIButton){
        if let track = trackOptional, let link = track.songLink {
            UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
        } else {
            let alertController = UIAlertController(title: "No Preview Available", message: "This song does not have a preview available", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        }
    }}
