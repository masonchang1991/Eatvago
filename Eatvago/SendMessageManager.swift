//
//  SentMessageManager.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/14.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Firebase

protocol SendMessageDelegate:class {
    
    func manager(_ manager: SendMessageManager, success: String)
    
    func manager(_ manager: SendMessageManager, didFailwith error: Error)
    
}

enum SendMessagerError: Error {
    
    case invalidUser
    
}

class SendMessageManager {
    
    weak var delegate: SendMessageDelegate?
    
    var ref: DatabaseReference = DatabaseReference()
    
    func sendMessageToFireBase(message: String, connectionRoomId: String) {
        
        ref = Database.database().reference()
        
        guard let userId = Auth.auth().currentUser?.uid else {
            
            self.delegate?.manager(self, didFailwith: SendMessagerError.invalidUser)
            return
        }
        let todayUnformate = Date()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm:ss"
        
        let today = dateFormatter.string(from: todayUnformate)
        
        let messageStruct = ["userId": userId, "message": message, "createdTime": today]
        
        ref.child("Chat Room").child(connectionRoomId).childByAutoId().setValue(messageStruct)
        ref.child("Chat Room").child(connectionRoomId).child("last message").setValue(messageStruct)
        
        self.delegate?.manager(self, success: "message sent")
        
    }
    
}
