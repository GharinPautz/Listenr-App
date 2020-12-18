//
//  ViewController.swift
//  Listenr
//  This is Ghar Pautz and Kellie Colson's final proejct for iOS App Development Fall, 2020. This program calls Spotify's Authentication, Search, and Recommendations APIs to produce songs for users based on their favorite tracks, artists, and genres of music. Additionally, the music data generated is stored using Firebase Firestore in the current user's account so they are able to access it again when they reopen the app after logging out.
//  CPSC 315-02, Fall 2020
//  Final Project
//
//  Created by Colson, Kellie Anne on 11/27/20.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // listen for user to change
        handle = Auth.auth().addStateDidChangeListener({ (Auth, User) in
            // user is active
        })

        Auth.auth().removeStateDidChangeListener(handle!)
    }

    /*
      Logs in user with provided credentials given they are correct and do not throw any errors

      Parameter sender: reference to UIButton pressed by user to login to the app
    */
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        // check the email text field is not empty
        if emailTextField.text == "" {
            // email text field is empty, notify user with an alert
            let alertController = UIAlertController(title: "Missing Email", message: "An email for your account has not been entered", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        // check the password text field is not empty
        else if passwordTextField.text == "" {
            // password text field is empty, notify user with an alert
            let alertController = UIAlertController(title: "Missing Password", message: "A password for your account has not been entered", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }

        if let email = emailTextField.text, let password = passwordTextField.text {
            // sign in user with Firebase Authentication
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let resultError = error {
                    print(resultError)
                    if let errCode = resultError as NSError? {
                        // send appropriate alerts based on common error codes
                        switch AuthErrorCode(rawValue: errCode.code) {
                        case .wrongPassword:
                            print("wrong password")
                            let alertController = UIAlertController(title: "Wrong Password", message: "The password entered does not match the account with the given email", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self!.present(alertController, animated: true, completion: nil)
                        case .invalidEmail:
                            print("invalid email")
                            let alertController = UIAlertController(title: "Invalid Email", message: "The email entered is not registered with an account", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self!.present(alertController, animated: true, completion: nil)
                        default:
                            print("other error")
                            let alertController = UIAlertController(title: "Login Error", message: "An error occured logging you in. Make sure the credentials you have entered are correct.", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self!.present(alertController, animated: true, completion: nil)
                        }
                    }
                } else {
                    print("successfully logged in user")
                    print(authResult!)
                    // should segue to next screen
                    self!.performSegue(withIdentifier: "loginSegue", sender: self)

                }
            }
        }
    }
}
