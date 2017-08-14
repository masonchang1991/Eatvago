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
       self.matchRoomTableView.reloadData()
       // 剪2是因為最後一筆 is last message

        
    }
    
    func manager(_ manager: ChatObserverManager, didFailWith error: Error) {
        
    }

    
}
