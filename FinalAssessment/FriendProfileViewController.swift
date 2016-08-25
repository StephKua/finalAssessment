//
//  FriendProfileViewController.swift
//  FinalAssessment
//
//  Created by Skkz on 25/08/2016.
//  Copyright © 2016 Skkz. All rights reserved.
//

import UIKit
import Firebase

class FriendProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var firebaseRef = FIRDatabase.database().reference()
    var userList = [String]()
    var listOfUID = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllUsers()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getAllUsers() {
        let userRef = firebaseRef.child("users")
        
        userRef.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
            
            if let userDict = snapshot.value as? [String: AnyObject] {
                if snapshot.key != User.currentUserUid() {
                    if let userUID = snapshot.key as? String {
                        self.listOfUID.append(userUID)
                    }
                    
                    if let userName = userDict["username"] as? String {
                        self.userList.append(userName)
                        self.tableView.reloadData()
                    }
                }
            }
            
        })
    }
    
    func isFriendChecking() {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendcell", forIndexPath: indexPath)
        cell.textLabel?.text = self.userList[indexPath.row]
        cell.detailTextLabel?.text = self.listOfUID[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }
    
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "friendProfileSegue"{
            let destination = segue.destinationViewController as! AddFriendViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            destination.friendUID = self.listOfUID[(indexPath.row)]
            destination.title = self.userList[indexPath.row]
        }
    }


}
