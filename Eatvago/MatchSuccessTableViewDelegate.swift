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
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
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
            messageCell.chatView.backgroundColor = UIColor(red: 13.0/255.0, green: 70.0/255.0, blue: 188.0/255.0, alpha: 0.8)
            
            messageCell.chatView.layer.shadowOffset = CGSize(width: 0, height: 1)
            messageCell.chatView.layer.shadowColor = UIColor.asiGreyishBrown.cgColor
            messageCell.chatView.layer.shadowOpacity = 0.6
            messageCell.chatView.layer.shadowRadius = 2
            messageCell.chatView.clipsToBounds = false
            
            messageCell.chatLabel.textColor = UIColor.white
            
            
            return messageCell
            
            
            
        } else {
            
            guard let messageCell = tableView.dequeueReusableCell(withIdentifier: "oppositePeopleChat", for: indexPath) as? OppositePeopleChatTableViewCell else {
                
                return UITableViewCell()
            }
            
            messageCell.chatLabel.text = self.chatRoomMessages[indexPath.row].message
            messageCell.chatLabel.textColor = UIColor.white

            
            messageCell.chatView.backgroundColor = UIColor(red: 13.0/255.0, green: 70.0/255.0, blue: 188.0/255.0, alpha: 0.8)
            messageCell.chatView.layer.shadowOffset = CGSize(width: 0, height: 1)
            messageCell.chatView.layer.shadowColor = UIColor.asiGreyishBrown.cgColor
            messageCell.chatView.layer.shadowOpacity = 0.6
            messageCell.chatView.layer.shadowRadius = 2
            messageCell.chatView.clipsToBounds = false
            
            messageCell.userPhotoImageView.image = self.oppositePeopleImageView?.image
            messageCell.userPhotoImageView.contentMode = .scaleAspectFit
            messageCell.userPhotoImageView.layer.cornerRadius = messageCell.userPhotoImageView.frame.width / 2
            
            
            return messageCell
            
        }
        
        
    }
    
    
}


