//
//  ViewController.swift
//  Listenr
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
        super.viewWillDisappear(animated)
        
        handle = Auth.auth().addStateDidChangeListener({ (Auth, User) in
            // get user's music preferences
            //print(User!)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Missing Email", message: "An email for your account has not been entered", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        } else if passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Missing Password", message: "A password for your account has not been entered", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let resultError = error {
                    print(resultError)
                    if let errCode = resultError as NSError? {
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

