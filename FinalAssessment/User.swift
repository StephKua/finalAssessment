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
    
    class func removeUserUid () {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("uid")
    }
    
}
