//
//  AddFriendViewController.swift
//  FinalAssessment
//
//  Created by Skkz on 25/08/2016.
//  Copyright © 2016 Skkz. All rights reserved.
//

import UIKit
import Firebase

class AddFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var firebaseRef = FIRDatabase.database().reference()
    var friendUID : String?
    var friendStatus = [String]()
    var friendUserName : String!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        getStatus()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendStatus", forIndexPath: indexPath)
        cell.textLabel?.text = self.friendUserName
        cell.detailTextLabel?.text = self.friendStatus[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendStatus.count
    }
    
    func getStatus() {
        let firebaseRef = FIRDatabase.database().reference()
        let userRef = firebaseRef.child("Status")
        
        userRef.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
            if let tweetDict = snapshot.value as? [String : AnyObject]{
                let userID = tweetDict["userID"] as! String
                if ( userID == self.friendUID) {
                    if let tweetText = tweetDict["status"] as? String{
                        self.friendStatus.append(tweetText)
                        self.tableView.reloadData()
                    }
                }
            }
        })
        
    }
    func getUser() {
        let firebaseRef = FIRDatabase.database().reference()
        let userRef = firebaseRef.child("users")
        
        userRef.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
            if let tweetDict = snapshot.value as? [String : AnyObject]{
                print (snapshot.key)
                if (snapshot.key == self.friendUID) {
                    if let tweetText = tweetDict["username"] as? String{
                        self.friendUserName = tweetText
                        self.tableView.reloadData()
                    }
                }
            }
        })
        
    }
    
    @IBAction func addFriend(sender: AnyObject) {
        let firebaseRef = FIRDatabase.database().reference()
        firebaseRef.child("users").child(User.currentUserUid()!).child("friends").child(self.friendUID!).setValue(true)
    }
    
    
    
}
