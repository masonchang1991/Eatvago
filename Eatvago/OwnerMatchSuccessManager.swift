//
//  MatchOwnerManager.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/10.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Firebase

protocol OwnerMatchSuccessDelegate: class {
    
    func manager(_ manager: OwnerMatchSuccessManager, matchSuccessRoomRef: DatabaseReference, connectionRoomId: String)
    
}

class OwnerMatchSuccessManager {
    
    weak var delegate: OwnerMatchSuccessDelegate?
    
    func matchSuccess(matchRoomRef: DatabaseReference, ref: DatabaseReference, type: String, matchRoomId: String, snapshot: DataSnapshot) {
        
        guard let value = snapshot.value as? Bool else { return }
        
        if value == true {

            let connectionRoomId = ref.childByAutoId().key
            
            matchRoomRef.child("Connection").setValue(connectionRoomId)
            
            self.fetchMatchRoom(ref: ref, type: type, matchRoomId: matchRoomId, completion: { [weak self] (matchRoom) in
                
                guard let `weakself` = self else { return }
                
                let connectionRoom = ["owner": matchRoom.owner,
                                      "ownerMatch": matchRoom.ownerMatchInfo,
                                      "ownerLocationLat": matchRoom.ownerLocationLat,
                                      "ownerLocationLon": matchRoom.ownerLocationLon,
                                      "attender": matchRoom.attender,
                                      "attenderLocationLat": matchRoom.attenderLocationLat,
                                      "attenderLocationLon": matchRoom.attenderLocationLon,
                                      "attenderMatchInfo": matchRoom.attenderMatchInfo]
                
                ref.child("Connection").child(connectionRoomId).setValue(connectionRoom)
    
                weakself.delegate?.manager(weakself, matchSuccessRoomRef: ref.child("Connection").child(connectionRoomId), connectionRoomId: connectionRoomId)
                
            })
            
        }

    }

    func fetchMatchRoom(ref: DatabaseReference, type: String, matchRoomId: String, completion: @escaping ((MatchRoom) -> Void)) {
        
        let matchRoomRef = ref.child("Match Room").child(type).child(matchRoomId)
        
        matchRoomRef.observeSingleEvent(of: .value, with: { (snapshot) in

            guard let matchRoomInfo = snapshot.value as? [String: Any] else {
                
                print("can't transform machRoomInfo")
                
                return
            }
            
            guard let owner = matchRoomInfo["owner"] as? String,
                let ownerLocationLat = matchRoomInfo["ownerLocationLat"] as? String,
                let ownerLocationLon = matchRoomInfo["ownerLocationLon"] as? String,
                let ownerMatchInfo = matchRoomInfo["ownerMatchInfo"] as? String,
                let attender = matchRoomInfo["attender"] as? String,
                let attenderLocationLat = matchRoomInfo["attenderLocationLat"] as? String,
                let attenderLocationLon = matchRoomInfo["attenderLocationLon"] as? String,
                let attenderMatchInfo = matchRoomInfo["attenderMatchInfo"] as? String else {
                    
                    print("JSON fail")
                    return
                    
            }
            
            let matchRoomData = MatchRoom(owner: owner,
                                          ownerLocationLat: ownerLocationLat,
                                          ownerLocationLon: ownerLocationLon,
                                          ownerMatchInfo: ownerMatchInfo,
                                          attender: attender,
                                          attenderLocationLat: attenderLocationLat,
                                          attenderLocationLon: attenderLocationLon,
                                          attenderMatchInfo: attenderMatchInfo,
                                          connection: nil)
            
            completion(matchRoomData)
            
        })
    }
    
}
