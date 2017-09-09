//
//  FetchMatchRoomData.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/11.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

protocol FetchMatchRoomDataDelegate: class {
    
    func manager(_ manager: FetchMatchRoomDataManager, matchRoomData: MatchPeopleInfo)
    
    func manager(_ manager: FetchMatchRoomDataManager, didFail with: String)
    
}

class FetchMatchRoomDataManager {
    
    weak var delegate: FetchMatchRoomDataDelegate?
    
    var ref: DatabaseReference =  Database.database().reference()

    var type: String = ""
    
    func getRoomData(by matchRoomRef: DatabaseReference, isRoomowner: Bool, type: String) {
        
        self.type = type
        
        matchRoomRef.observeSingleEvent(of: .value, with: { (snapshot) in

            guard
                let roomData = snapshot.value as? [String: Any],
                let ownerMatchInfo = roomData["ownerMatchInfo"] as? String,
                let attenderMatchInfo = roomData["attenderMatchInfo"] as? String else {
                    
                    self.delegate?.manager(self, didFail: "JSON FAIL")
                    return
            }
            
            if isRoomowner == true {
                
                self.getOppositePeopleInfo(oppositePeopleMatchInfoId: attenderMatchInfo, completion: { (name, gender, greetingText, photoURL) in
                    
                    let peopleImageView = UIImageView()
                    
                    if photoURL != nil {
                        
                        let url = URL(string: photoURL!)

                        peopleImageView.sd_setImage(with: url,
                                                    placeholderImage: UIImage(named: "UserDefaultIconForMatch"),
                                                    options: SDWebImageOptions.retryFailed,
                                                    completed: nil)
                        
                         let matchPeopleInfo = MatchPeopleInfo(oppositePeopleName: name,
                                                               oppositePeopleGender: gender,
                                                               oppositePeopleText: greetingText,
                                                               oppositePeoplePhotoURL: photoURL)
                        
                         self.delegate?.manager(self, matchRoomData: matchPeopleInfo)
                        
                    } else {
                        
                        let matchPeopleInfo = MatchPeopleInfo(oppositePeopleName: name,
                                                              oppositePeopleGender: gender,
                                                              oppositePeopleText: greetingText,
                                                              oppositePeoplePhotoURL: photoURL)
                        
                        self.delegate?.manager(self, matchRoomData: matchPeopleInfo)
                        
                    }
                    
                })
                
            } else {
                
                self.getOppositePeopleInfo(oppositePeopleMatchInfoId: ownerMatchInfo, completion: { [weak self] (name, gender, greetingText, photoURL) in
                    
                    guard let `weakself` = self else { return }
                    
                    let peopleImageView = UIImageView()
                    
                    if photoURL != nil {
                        
                        let url = URL(string: photoURL!)
                        
                        peopleImageView.sd_setImage(with: url,
                                                    placeholderImage: UIImage(named: "UserDefaultIconForMatch"),
                                                    options: SDWebImageOptions.retryFailed,
                                                    completed: nil)
                        
                        let matchPeopleInfo = MatchPeopleInfo(oppositePeopleName: name,
                                                              oppositePeopleGender: gender,
                                                              oppositePeopleText: greetingText,
                                                              oppositePeoplePhotoURL: photoURL)
                        
                        weakself.delegate?.manager(weakself, matchRoomData: matchPeopleInfo)
                        
                    } else {
                        
                        let matchPeopleInfo = MatchPeopleInfo(oppositePeopleName: name,
                                                              oppositePeopleGender: gender,
                                                              oppositePeopleText: greetingText,
                                                              oppositePeoplePhotoURL: photoURL)
                        
                        weakself.delegate?.manager(weakself, matchRoomData: matchPeopleInfo)
                        
                    }
                })
            }
        })
    }
    
    func getOppositePeopleInfo(oppositePeopleMatchInfoId: String, completion: @escaping ((String, String, String, String?) -> Void)) {
        
        ref.child("Match Info").child(type).child(oppositePeopleMatchInfoId).observe(.value, with: { (snapshot) in
            
            guard
                let peopleData = snapshot.value as? [String: Any],
                let name = peopleData["nickName"] as? String,
                let gender = peopleData["gender"] as? String,
                let greetingText = peopleData["greetingText"] as? String else {
                
                    self.delegate?.manager(self, didFail: "getOppositePeopleInfo fail")
                
                    return
            }
            
            if let photoURL = peopleData["UserPhotoURL"] as? String {
                
                print(photoURL)
                
                completion(name, gender, greetingText, photoURL)
                
            } else {
                
                completion(name, gender, greetingText, nil)
                
            }
        })
    }
}
