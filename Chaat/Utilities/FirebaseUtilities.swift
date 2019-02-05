//
//  FirebaseUtilities.swift
//  Chaat
//
//  Created by Admin on 2019/2/5.
//  Copyright © 2019 Sky. All rights reserved.
//

import Foundation
import Firebase

extension FirebaseApp {
    
    static func fetchUserWithUserUid(uid:String,completion:@escaping (User)->()) {
        let userRef = Database.database().reference().child("users").child(uid)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let userDictionary = snapshot.value as? [String:Any] else {return }
            let user = User(id: uid, dic: userDictionary)
            completion(user)
        }
    }
}
