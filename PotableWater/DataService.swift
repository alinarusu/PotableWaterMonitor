//
//  DataService.swift
//  PotableWater
//
//  Created by Voicu Narcis on 04/09/2016.
//  Copyright © 2016 Voicu Narcis. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class DataService{
    
    
    static let databaseReference = FIRDatabase.database().referenceFromURL("https://potable-water.firebaseio.com/")
    static let userReference = FIRDatabase.database().referenceFromURL("https://potable-water.firebaseio.com/users")
    static let waterItemsReference = FIRDatabase.database().referenceFromURL("https://potable-water.firebaseio.com/waterItems")
    
    static func createUser(uid: String, user: Dictionary<String, NSObject>){
        userReference.child(uid).setValue(user)
    }

//    static let dataService = DataService()
//    
//    private var ROOT_REF = Firebase(url: "https://potable-water.firebaseio.com/")
//    private var USER_REF = Firebase(url:  )
//    private var WATER_ITEMS_REF = Firebase(url: "https://potable-water.firebaseio.com/waterItems")
//    
//    var rootRef: Firebase{
//        return ROOT_REF
//    }
//    
//    var userRef: Firebase{
//        return USER_REF
//    }
//    
//    var currentUserRef: Firebase{
//        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
//        
//        let currentUser = Firebase(url: "\(rootRef)").childByAppendingPath("users").childByAppendingPath(userID)
//        
//        return currentUser
//    }
//    
//    var waterItemsRef: Firebase{
//        return WATER_ITEMS_REF
//    }
//    
}
