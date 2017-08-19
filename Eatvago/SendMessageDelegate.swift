//
//  sendMessageDelegate.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/14.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import SwifterSwift

extension MatchSuccessViewController: SendMessageDelegate {
    
    func manager(_ manager: SendMessageManager, success: String) {
        
        self.messageSentFromMe = true
        
    }
        
    func manager(_ manager: SendMessageManager, didFailwith error: Error) {
        
    }

}
