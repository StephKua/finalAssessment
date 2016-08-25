//
//  FeedViewController.swift
//  FinalAssessment
//
//  Created by Skkz on 25/08/2016.
//  Copyright © 2016 Skkz. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var firebaseRef = FIRDatabase.database().reference()
    var feed = [String]()
    var friend = [String]()
    var friendKey = [String]()
    var statusKey = [String]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friend.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedcell", forIndexPath: indexPath)
        cell.textLabel?.text = self.friend[indexPath.row]
        cell.detailTextLabel?.text = self.feed[indexPath.row]
        return cell
    }
    
    func getInfo() {
        let friendRef = firebaseRef.child("users").child(User.currentUserUid()!).child("friends")
        
        friendRef.observeEventType(.Value, withBlock:  { (snapshot) in
            if let friendDict = snapshot.value as? [String: AnyObject] {
                for (key, _) in friendDict {
                    self.friendKey.append(key)
                    self.getStatus()
                }
            }
        })
    }
    
    func getStatus() {
        
        for key in friendKey {
            let userFrdRef = firebaseRef.child("Status")
            userFrdRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
                if let statusDict = snapshot.value as? [String: AnyObject] {
                    let userID = statusDict["userID"] as! String
                    if (userID == key) {
                        self.statusKey.append(snapshot.key)
                        if let status = statusDict["status"] as? String {
                            self.feed.append(status)
                            self.getName(key)
                            self.tableView.reloadData()
                        }
                    }
                }
            })
        }
    }
    
    func getName(key: String) {
        let nameRef = firebaseRef.child("users").child(key)
        nameRef.observeEventType(.Value, withBlock: { (snapshot) in
            if let userDict = snapshot.value as? [String:AnyObject] {
                let username = userDict["username"] as! String
                self.friend.append(username)
                self.tableView.reloadData()
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "commentSegue"{
            let destination = segue.destinationViewController as! CommentViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            destination.key = self.statusKey[indexPath.row]
            destination.title = self.feed[indexPath.row]
        }
    }

}
