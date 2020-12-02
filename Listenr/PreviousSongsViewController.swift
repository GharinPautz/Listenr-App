//
//  PreviousSongsViewController.swift
//  Listenr
//
//  Created by Colson, Kellie Anne on 11/27/20.
//

import UIKit
import FirebaseAuth

class PreviousSongsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(PreviousSongsViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem ) {
        // logout
        do {
            try Auth.auth().signOut()
            print("successfully logged out user")
        } catch let error as NSError{
            print("error signing out \(error)")
        }
        
        // return to sign in view controller
        _ = navigationController?.popViewController(animated: true)
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

}
