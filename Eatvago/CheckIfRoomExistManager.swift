//
//  CheckIfRoomExistManager.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/10.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Firebase

protocol CheckIfRoomExistDelegate: class {
    
    func manager(_ manager: CheckIfRoomExistManager, didGet roomId: String)
    
    func manager(_ manager: CheckIfRoomExistManager, be roomOwner: String)
    
}

class CheckIfRoomExistManager {
    
    weak var delegate: CheckIfRoomExistDelegate?
    
    var ref: DatabaseReference =  Database.database().reference()
    
    func checkIfRoomExist(type: String) {
       
        findRoom(type: type) { [weak self] (finded, key) in
            
            guard let `weakself` = self else { return }
            
            if finded == false {

                weakself.delegate?.manager(weakself, be: "you are a room owner")

            } else {

                weakself.delegate?.manager(weakself, didGet: key)
                
            }
        }
    }
    
    func findRoom(type: String, completion: @escaping ((Bool, String) -> Void)) {

         ref.child("Match Room").child(type).queryOrdered(byChild: "isLocked").queryEqual(toValue: false).queryLimited(toFirst: 1).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value as? [String: Any] else {
                
                //回傳沒房間
                completion(false, "Null")
                self.ref.removeAllObservers()
                return
            }
            
            print(value)
            
            let key = Array(value.keys)[0]
            
            self.ref.removeAllObservers()
            
            completion(true, key)
    
        })
        
    }
    
}
