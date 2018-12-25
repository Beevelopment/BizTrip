//
//  DataService.swift
//  BizTrip
//
//  Created by Carl Henningsson on 12/30/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USER = DB_BASE.child("user")
    private var _REF_FEEDBACK = DB_BASE.child("feedback")
    private var _REF_VERSION = DB_BASE.child("version")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_USER: DatabaseReference {
        return _REF_USER
    }
    var REF_FEEDBACK: DatabaseReference {
        return _REF_FEEDBACK
    }
    var REF_VERSION: DatabaseReference {
        return _REF_VERSION
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_USER.child(uid).updateChildValues(user)
    }
}
