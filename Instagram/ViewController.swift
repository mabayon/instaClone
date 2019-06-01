//
//  ViewController.swift
//  Instagram
//
//  Created by Mahieu Bayon on 18/09/2018.
//  Copyright © 2018 M4m0ut. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signupOrLoginButton: UIButton!
    @IBOutlet weak var switchLoginModeButton: UIButton!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    var signupModeActive = true
    
    @IBAction func signupOrLogin(_ sender: Any) {
        
        if email.text == "" || password.text == "" {
         
            self.displayAlert(title: "Error", message: "Please enter an email and a password")
        
        } else {
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicator.center = self.view.center
            
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
        
            if signupModeActive {

                let user = PFUser()
     
                user.username = email.text
                user.email = email.text
                user.password = password.text

                user.signUpInBackground(block: { (success, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                
                    if let error = error {
                    
                        self.displayAlert(title: "Could not sign you up", message: error.localizedDescription)
                    
                    } else {
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                })
            
                email.text = ""
                password.text = ""
        
            } else {
        
                PFUser.logInWithUsername(inBackground: email.text!, password: password.text!, block: { (user, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                
                    if let error = error {
                    
                        self.displayAlert(title: "Could not log in you", message: error.localizedDescription)
                    
                    } else {
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                })
            
                email.text = ""
                password.text = ""
            }
        }
    }
    
    @IBAction func switchLoginMode(_ sender: Any) {
        
        if signupModeActive {
            
            signupModeActive = false
            
            signupOrLoginButton.setTitle("Log In", for: [])
            
            switchLoginModeButton.setTitle("Sign Up", for: [])
            
            questionLabel.text = "Don't have an account ?"
        
        } else {
            
            signupModeActive = true
            
            signupOrLoginButton.setTitle("Sign Up", for: [])
            
            switchLoginModeButton.setTitle("Log In", for: [])
            
            questionLabel.text = "Already have an account ?"
        }
    }
    
    func displayAlert(title: String, message: String) {
      
        let alertController = UIAlertController(title: "Error", message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            
            self.performSegue(withIdentifier: "showUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

