//
//  ChatObserverManager.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/14.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Firebase



protocol ChatObserverDelegate:class {
    
    func manager(_ manager: ChatObserverManager, didGet messages: [Message])
    
    func manager(_ manager: ChatObserverManager, didFailWith error: Error)
    
}

enum ObserverMessagerError: Error {
    
    case invalidData
    case guardletFail
    
    
}
class ChatObserverManager {
    
    weak var delegate: ChatObserverDelegate?
    
    var ref: DatabaseReference = DatabaseReference()
    
    func setObserver(connectionRoomId: String) {
        
        var messages: [Message] = []
        
        ref = Database.database().reference()
        
        ref.child("Chat Room").child(connectionRoomId).observe(.value, with: { (snapshot) in
            print(snapshot,"------------")
            for messageStruct in snapshot.children {
                
                guard let messageStructSnapshot = messageStruct as? DataSnapshot else {
                    
                    return
                }
                
                guard let messageDictionary = messageStructSnapshot.value as? [String: String] else {
                    self.delegate?.manager(self, didFailWith: ObserverMessagerError.guardletFail)
                    
                    return
                }
                print(messageDictionary, "dic~~~~~~~~")
                guard let userId = messageDictionary["userId"],
                    let message = messageDictionary["message"],
                    let createdTime = messageDictionary["createdTime"] else {
                        self.delegate?.manager(self, didFailWith: ObserverMessagerError.guardletFail)
                        return
                }
                print(userId, "user~~~~~~~")
                let singleMessage = Message(userId: userId, message: message, createdTime: createdTime)
                
                messages.append(singleMessage)
            }
            
            self.delegate?.manager(self, didGet: messages)
            
        })
        
    }
    
    
    
    
    
    
    
}
