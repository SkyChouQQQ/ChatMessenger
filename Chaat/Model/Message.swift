//
//  Message.swift
//  Chaat
//
//  Created by Admin on 2018/12/8.
//  Copyright © 2018 Sky. All rights reserved.
//

import UIKit
import Firebase

@objcMembers
class Message: NSObject {
    var messageFromId:String?
    var messageToId:String?
    var timeStamp:NSNumber?
    var text:String?
    var imageUrl:String?
    var imageWidth:NSNumber?
    var imageHeight:NSNumber?
    
    func checkChatPartnerId()->String? {
        return messageFromId == Auth.auth().currentUser?.uid ? messageToId : messageFromId
    }
    init(dictionary:[String:Any]) {
        super.init()
        messageFromId = dictionary["messageFromId"] as? String
        messageToId = dictionary["messageToId"] as? String
        timeStamp = dictionary["timeStamp"] as? NSNumber
        text = dictionary["text"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        
    }
    
}



