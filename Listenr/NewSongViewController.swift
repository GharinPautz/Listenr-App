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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func addToLibraryButtonPressed(_ sender: UIButton) {
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
