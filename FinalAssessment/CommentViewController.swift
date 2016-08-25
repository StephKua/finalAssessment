//
//  CommentViewController.swift
//  FinalAssessment
//
//  Created by Skkz on 25/08/2016.
//  Copyright © 2016 Skkz. All rights reserved.
//

import UIKit
import Firebase

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    var firebaseRef = FIRDatabase.database().reference()
    var key = String()
    var commentKey = [String]()
    var listOfComments = [String]()
    var listOfUsers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfo()
    }
    
    func getInfo() {
        let statusRef = firebaseRef.child("Status").child(key).child("comment")
        statusRef.observeEventType(.Value, withBlock:  { (snapshot) in
            if let commentDict = snapshot.value as? [String: AnyObject] {
                for (key, _) in commentDict {
                    self.commentKey.append(key)
                    self.getComment()
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func getComment() {
        for key in commentKey {
            let commentRef = firebaseRef.child("Comment").child(key)
            commentRef.observeEventType(.Value, withBlock: { (snapshot) in
                if let commentDict = snapshot.value as? [String: AnyObject] {
                    let comment = commentDict["comment"] as! String
                    self.listOfComments.append(comment)
                    
                    let userID = commentDict["userID"] as! String
                    self.getUser(userID)
                    self.tableView.reloadData()
                }
                
            })
        }
    }
    
    func getUser(ID: String) {
        let nameRef = firebaseRef.child("users").child(ID)
        
        nameRef.observeEventType(.Value, withBlock:  { (snapshot) in
            if let userDict = snapshot.value as? [String: AnyObject] {
                let username = userDict["username"] as! String
                self.listOfUsers.append(username)
                self.tableView.reloadData()
            }
        })
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentcell", forIndexPath: indexPath)
        cell.textLabel?.text = self.listOfUsers[indexPath.row]
        cell.detailTextLabel?.text = self.listOfComments[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfUsers.count
    }
    
    @IBAction func addCommentBtnOnClicked(sender: UIButton) {
        guard let comment = commentTextField.text else { return }
        
        let commentUID = NSUUID().UUIDString
        
        let commentDict = ["comment": comment, "userID": User.currentUserUid()!]
        
        firebaseRef.child("Comment").child(commentUID).setValue(commentDict)
        firebaseRef.child("Status").child(key).child("comment").child(commentUID).setValue(true)
        
        getInfo()
        
    }
    
    
}
