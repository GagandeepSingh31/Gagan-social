//
//  DataService.swift
//  Gagan-social
//
//  Created by Gagandeep Singh on 3/29/17.
//  Copyright © 2017 Gagandeep Singh. All rights reserved.
//

import Foundation
import Firebase


// Reffering to the firebase database through going into the googleService plist (DATABASE_URL).
let DB_BASE = FIRDatabase.database().reference()


class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE : FIRDatabaseReference {
        return _REF_BASE
    }
    
    var  REF_POSTS : FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS : FIRDatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid : String , userData : Dictionary< String , String>) {
         REF_USERS.child(uid).updateChildValues(userData)
    }
}

