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
    var listOfKeys = [String]()
    var listOfStatus = [String]()
    var currentUser = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfStatus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = self.currentUser
        cell.detailTextLabel?.text = self.listOfStatus[indexPath.row]
        return cell
    }
    
    func getInfo() {
        
        let userRef = firebaseRef.child("users").child(User.currentUserUid()!)
        
        userRef.observeEventType(.Value, withBlock:  { (snapshot) in
            if let userDict = snapshot.value as? [String: AnyObject] {
                if let userName = userDict["username"] as? String {
                    self.currentUser = userName
                    self.tableView.reloadData()
                }
            }
        })
        
        let statusRef = firebaseRef.child("Status")
        
        statusRef.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
            if let statusDict = snapshot.value as? [String: AnyObject] {
                self.listOfKeys.append(snapshot.key)
                let userID = statusDict["userID"] as! String
                if (userID == User.currentUserUid()!) {
                    if let status = statusDict["status"] as? String {
                        self.listOfStatus.append(status)
                        self.tableView.reloadData()
                    }
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
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            self.listOfStatus.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
            print("delete \(indexPath.row)")
            let removeRef = self.firebaseRef.child("Status").child(self.listOfKeys[indexPath.row])
            let removeUserRef = self.firebaseRef.child("users").child(User.currentUserUid()!).child("status").child(self.listOfKeys[indexPath.row])
            removeRef.removeValue()
            removeUserRef.removeValue()
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    @IBAction func logOutBtnClicked(sender: UIBarButtonItem) {
        
        try!FIRAuth.auth()?.signOut()
        User.removeUserUid()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let Controller = storyboard.instantiateViewControllerWithIdentifier("LogInViewController") as? UIViewController {
            self.presentViewController(Controller, animated: true, completion: nil)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editStatusSegue"{
            let destination = segue.destinationViewController as! EditStatusViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            destination.userStatus = self.listOfStatus[(indexPath.row)]
            destination.userStatusKey = self.listOfKeys[indexPath.row]
        }
    }

    
}
