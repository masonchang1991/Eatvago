//
//  ChatObserverDelegate.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/14.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit

extension MatchSuccessViewController: ChatObserverDelegate {

    func manager(_ manager: ChatObserverManager, didGet messages: [Message]) {
        
       self.chatRoomMessages = messages
       
        if self.messageSentFromMe == true && self.chatRoomMessages.count > 3 {
        
            self.matchRoomTableView.reloadData()
            
            self.matchRoomTableView.scrollToBottom(animated: true)
            
            self.messageSentFromMe = false
            
        } else {
        
            self.matchRoomTableView.reloadData()
            
        }
    
    }
    
    func manager(_ manager: ChatObserverManager, didFailWith error: Error) {
        
    }
}
