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
            
            guard let roomData = snapshot.value as? [String: Any] else { return }
            
            guard let owner = roomData["owner"] as? String,
                let ownerLocationLat = roomData["ownerLocationLat"] as? String,
                let ownerLocationLon = roomData["ownerLocationLon"] as? String,
                let ownerMatchInfo = roomData["ownerMatchInfo"] as? String,
                let attender = roomData["attender"] as? String,
                let attenderLocationLat = roomData["attenderLocationLat"] as? String,
                let attenderLocationLon = roomData["attenderLocationLon"] as? String,
                let attenderMatchInfo = roomData["attenderMatchInfo"] as? String else {
                    
                    self.delegate?.manager(self, didFail: "JSON FAIL")
                    return
            }

            let matchRoom = MatchRoom(owner: owner,
                                      ownerLocationLat: ownerLocationLat,
                                      ownerLocationLon: ownerLocationLon,
                                      ownerMatchInfo: ownerMatchInfo,
                                      attender: attender,
                                      attenderLocationLat: attenderLocationLat,
                                      attenderLocationLon: attenderLocationLon,
                                      attenderMatchInfo: attenderMatchInfo,
                                      connection: nil)
            
            if isRoomowner == true {
                
                self.getOppositePeopleInfo(oppositePeopleMatchInfoId: attenderMatchInfo, completion: { (name, gender, greetingText, photoURL) in
                    
                    let peopleImageView = UIImageView()
                    
                    if photoURL != nil {
                        
                        let url = URL(string: photoURL!)
                        
                        if gender == "male" {
                            
                            peopleImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "boy"), options: SDWebImageOptions.refreshCached, completed: nil)
                            
                        } else {
                            
                            peopleImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "girl"), options: SDWebImageOptions.refreshCached, completed: nil)
                            
                        }
                        
                         let matchPeopleInfo = MatchPeopleInfo(oppositePeopleName: name, oppositePeopleGender: gender, oppositePeopleText: greetingText, oppositePeopleImageView: peopleImageView)
                        
                         self.delegate?.manager(self, matchRoomData: matchPeopleInfo)

                        
                    } else {
                        
                        
                        if gender == "male" {
                            
                            peopleImageView.sd_setImage(with: nil, placeholderImage: UIImage(named: "boy"), options: SDWebImageOptions.refreshCached, completed: nil)
                            
                        } else {
                            
                            peopleImageView.sd_setImage(with: nil, placeholderImage: UIImage(named: "girl"), options: SDWebImageOptions.refreshCached, completed: nil)
                            
                        }
                        
                        let matchPeopleInfo = MatchPeopleInfo(oppositePeopleName: name, oppositePeopleGender: gender, oppositePeopleText: greetingText, oppositePeopleImageView: peopleImageView)
                        
                        self.delegate?.manager(self, matchRoomData: matchPeopleInfo)
                        
                    }
                    
                })
                
                
                
            } else {
                
                self.getOppositePeopleInfo(oppositePeopleMatchInfoId: ownerMatchInfo, completion: { (name, gender, greetingText, photoURL) in
                    
                    let peopleImageView = UIImageView()
                    
                    if photoURL != nil {
                        
                        let url = URL(string: photoURL!)
                        
                        if gender == "male" {
                            
                            peopleImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "boy"), options: SDWebImageOptions.refreshCached, completed: nil)
                            
                        } else {
                            
                            peopleImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "girl"), options: SDWebImageOptions.refreshCached, completed: nil)
                            
                        }
                        
                        let matchPeopleInfo = MatchPeopleInfo(oppositePeopleName: name, oppositePeopleGender: gender, oppositePeopleText: greetingText, oppositePeopleImageView: peopleImageView)
                        
                        self.delegate?.manager(self, matchRoomData: matchPeopleInfo)
                        
                        
                    }else {
                        
                        
                        if gender == "male" {
                            
                            peopleImageView.sd_setImage(with: nil, placeholderImage: UIImage(named: "boy"), options: SDWebImageOptions.refreshCached, completed: nil)
                            
                        } else {
                            
                            peopleImageView.sd_setImage(with: nil, placeholderImage: UIImage(named: "girl"), options: SDWebImageOptions.refreshCached, completed: nil)
                            
                        }
                        
                        let matchPeopleInfo = MatchPeopleInfo(oppositePeopleName: name, oppositePeopleGender: gender, oppositePeopleText: greetingText, oppositePeopleImageView: peopleImageView)
                        
                        self.delegate?.manager(self, matchRoomData: matchPeopleInfo)
                        
                    }
                    
                })
                
            }
            
        })
        
    }
    
    
    
    func getOppositePeopleInfo(oppositePeopleMatchInfoId: String, completion: @escaping ((String, String, String, String?) -> Void)) {
        
        ref.child("Match Info").child(type).child(oppositePeopleMatchInfoId).observe(.value, with: { (snapshot) in
            
            guard let peopleData = snapshot.value as? [String: Any] else {
                
                self.delegate?.manager(self, didFail: "getOppositePeopleInfo fail")
                
                return
            }
            
            guard let name = peopleData["nickName"] as? String,
                let gender = peopleData["gender"] as? String,
                let greetingText = peopleData["greetingText"] as? String else {
                    
                    self.delegate?.manager(self, didFail: "getOppositePeopleInfo fail")
                    
                    return
                    
            }
            
            
            if let photoURL = peopleData["photo"] as? String {
                
                
                completion(name, gender, greetingText, photoURL)
                
                
                
            } else {
                
                
                completion(name, gender, greetingText, nil)
                
                
            }
            
            
            
        })
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}


