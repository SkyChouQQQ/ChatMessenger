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
    
    func checkChatPartnerId()->String? {
        return messageFromId == Auth.auth().currentUser?.uid ? messageToId : messageFromId
    }
}
