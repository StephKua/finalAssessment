//
//  SignUpViewController.swift
//  FinalAssessment
//
//  Created by Skkz on 25/08/2016.
//  Copyright © 2016 Skkz. All rights reserved.
//

import Cocoa
import Firebase

class SignUpViewController: ReusableKeyboardViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    private var firebaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTapped()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signUpBtnOnClicked(sender: UIButton) {
                guard let username = userNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            if let user = user {
                let userDict = ["email": email, "username": username]
                self.firebaseRef.child("users").child(user.uid).setValue(userDict)
                NSUserDefaults.standardUserDefaults().setValue(user.uid, forKey: "uid")
                User.signIn(user.uid)
                self.performSegueWithIdentifier("LoginSegue", sender: sender)
            } else {
                let controller = UIAlertController(title: "Error", message: (error?.localizedDescription), preferredStyle: .Alert)
                let dismissBtn = UIAlertAction(title: "Try Again", style: .Default, handler: nil)
                controller.addAction(dismissBtn)
                
                self.presentViewController(controller, animated: true, completion: nil)
                
            }
            
        })
        
    }
    
    
    @IBAction func backToLogin (segue: UIStoryboardSegue) {
        
    }
    
}
