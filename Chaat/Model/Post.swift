//
//  Post.swift
//  Chaat
//
//  Created by Admin on 2019/2/6.
//  Copyright © 2019 Sky. All rights reserved.
//

import Foundation

struct Post {
    var id:String
    let creationDate:Date
    let caption:String
    let imageUrl :String
    var isLike = false
    let user:User
    init(user:User,dictionary:[String:Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.id = dictionary["id"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}

