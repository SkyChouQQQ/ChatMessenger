//
//  User.swift
//  Chaat
//
//  Created by Admin on 2018/12/6.
//  Copyright © 2018 Sky. All rights reserved.
//

import Foundation

@objcMembers
class User:NSObject {
    var id:String?
    var name:String?
    var email:String?
    var profileImageUrl:String?
    
    init(id:String,dic:[String:Any]) {
        self.id = id
        self.name = dic["name"] as? String ?? ""
        self.profileImageUrl = dic["profileImageUrl"] as? String ?? ""
    }
}
