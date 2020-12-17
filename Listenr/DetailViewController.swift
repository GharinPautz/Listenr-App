//
//  DetailViewController.swift
//  Listenr
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

    func updateUI() {
        if let track = trackOptional {
            songTitleLabel.text = track.title
            artistLabel.text = track.artist
        }
    }
    
        
    @IBAction func playButtonPressed(sender: UIButton){
        if let track = trackOptional, let link = track.songLink {
            UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
        } else {
            let alertController = UIAlertController(title: "No Preview Available", message: "This song does not have a preview available", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        }
    }}
