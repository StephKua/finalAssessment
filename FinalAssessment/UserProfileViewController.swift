//
//  UserProfileViewController.swift
//  FinalAssessment
//
//  Created by Skkz on 25/08/2016.
//  Copyright © 2016 Skkz. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var newStatusTextField: UITextField!
    var firebaseRef = FIRDatabase.database().reference()
    var listOfStatus = [String]()
    var currentUser = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = currentUser
        cell.detailTextLabel?.text = listOfStatus[indexPath.row]
        return cell
    }
    
    func getInfo() {
        let currentUserRef = firebaseRef.child("users").child(User.currentUserUid()!)
        
        currentUserRef.observeEventType(.Value, withBlock:  { (snapshot) in
            if let userInfo = User(snapshot: snapshot) {
                self.currentUser = userInfo.userName
            }
            
        })
        
        currentUserRef.child("status").observeEventType(.Value, withBlock: { (snapshot) in
            if let statusDict = snapshot.value as? [String:Bool] {
            for (key, _) in statusDict {
                self.firebaseRef.child("Status").child(key).observeSingleEventOfType(.ChildAdded, withBlock: { (statusSnapshot) in
                    let status = statusSnapshot.value as? String
                    self.listOfStatus.append(status!)
                    self.tableView.reloadData()
                })
            }
            }
        })
    }
    
    @IBAction func addStatusBtnOnClicked(sender: UIBarButtonItem) {
        guard let newStatus = newStatusTextField.text else { return }
        let statusDict = ["status": newStatus, "userID": User.currentUserUid()!]
        let statusUID = NSUUID().UUIDString
        self.firebaseRef.child("users").child(User.currentUserUid()!).child("status").child(statusUID).setValue(true)
        self.firebaseRef.child("Status").child(statusUID).setValue(statusDict)
    }
    
}
