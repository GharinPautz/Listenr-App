//
//  CreateAccountViewController.swift
//  Listenr
//
//  Created by Colson, Kellie Anne on 11/27/20.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var genresTextField: UITextField!
    @IBOutlet var favoriteSongsTextField: UITextField!
    @IBOutlet var favoriteArtistsTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
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
