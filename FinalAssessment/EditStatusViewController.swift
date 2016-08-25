//
//  EditStatusViewController.swift
//  FinalAssessment
//
//  Created by Skkz on 25/08/2016.
//  Copyright © 2016 Skkz. All rights reserved.
//

import UIKit
import Firebase

class EditStatusViewController: UIViewController, UITextFieldDelegate {
    var userStatus:String!
    var userStatusKey:String!
    let firebaseRef = FIRDatabase.database().reference()
    
    @IBOutlet var statusTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusTxtFld.text = userStatus
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.firebaseRef.child("Status").child(self.userStatusKey).child("status").setValue(self.statusTxtFld.text)
        self.navigationController?.popViewControllerAnimated(true)
        return true
    }
    
    
    
    

}
