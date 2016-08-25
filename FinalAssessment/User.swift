//
//  User.swift
//  FinalAssessment
//
//  Created by Skkz on 25/08/2016.
//  Copyright © 2016 Skkz. All rights reserved.
//

import Foundation
import Firebase

class User: NSObject {
    
    var friends: [String: Bool]
    var userName: String
    var status: [String: Bool]
    
    init?(snapshot: FIRDataSnapshot) {
        guard let dict = snapshot.value as? [String: AnyObject] else {
            return nil
        }
        
        if let name = dict["username"] as? String {
            self.userName = name
        } else {
            self.userName = ""
        }
        
        if let friends = dict["friends"] as? [String: Bool] {
            self.friends = friends
        } else {
            self.friends = [:]
        }
        
        if let status = dict["status"] as? [String:Bool] {
            self.status = status
        } else {
            self.status = [:]
        }
    }
    
    
    class func signIn(uid:String){
        NSUserDefaults.standardUserDefaults().setValue(uid, forKeyPath: "uid")
    }
    
    class func isSignedIn() -> Bool{
        if let _ = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
            return true
            
        }else{
            return false
        }
    }
    
    class func currentUserUid() -> String?{
        return NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
    }
    
}
