//
//  Comment.swift
//  Chaat
//
//  Created by Admin on 2019/2/6.
//  Copyright © 2019 Sky. All rights reserved.
//

import Foundation

struct Comment {
    var user:User
    var text:String
    var uid:String
    
    init(user:User,dictionary:[String:Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
