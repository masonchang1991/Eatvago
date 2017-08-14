//
//  MatchSuccessTableViewDelegate.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/14.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Firebase


extension MatchSuccessViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        return UITableViewAutomaticDimension
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatRoomMessages.count - 1
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let myUserId = Auth.auth().currentUser?.uid else {
            return UITableViewCell()
        }
        
        if self.chatRoomMessages[indexPath.row].userId == myUserId {
        
            guard let messageCell = tableView.dequeueReusableCell(withIdentifier: "myChat", for: indexPath) as? MyChatTableViewCell else {
                
                return UITableViewCell()
            }
            
            messageCell.chatLabel.text = self.chatRoomMessages[indexPath.row].message
            
            return messageCell
            
            
            
        } else {
            
            guard let messageCell = tableView.dequeueReusableCell(withIdentifier: "oppositePeopleChat", for: indexPath) as? OppositePeopleChatTableViewCell else {
                
                return UITableViewCell()
            }
            
            messageCell.chatLabel.text = self.chatRoomMessages[indexPath.row].message
            
            return messageCell
            
        }
        
        
    }
    
    
}


