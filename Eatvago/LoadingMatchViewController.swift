//
//  LoadingMatchViewController.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/10.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import NVActivityIndicatorView

class LoadingMatchViewController: UIViewController, OwnerMatchSuccessDelegate, FetchMatchRoomDataDelegate {

    @IBOutlet weak var oppositePeopleNameLabel: UILabel!
    
    @IBOutlet weak var oppositePeopleImageView: UIImageView!
    
    @IBOutlet weak var oppositePeopleInfoTextView: UITextView!
    
    @IBOutlet weak var matchLoadingView: NVActivityIndicatorView!
    
    @IBOutlet weak var myNameLabel: UILabel!
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var myTextView: UITextView!
    
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var declineButton: UIButton!

    var matchRoomId = ""
    
    var type = ""
    
    var myName = ""
    
    var myGeetingText = ""
    
    var myPhotoURl = ""
    
    var myGender = ""
    
    var ref: DatabaseReference = DatabaseReference()
    
    var ownerSuccessManager = OwnerMatchSuccessManager()
    
    var fetchMatchRoomDataManager = FetchMatchRoomDataManager()
    
    var matchRoomRef = DatabaseReference()
    
    var ownerSnapshot = DataSnapshot()
    
    var isARoomOwner: Bool = true
    
    // 讓observer 第一次設定時不要run
    var runTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        acceptButton.isHidden = true
        declineButton.addTarget(self, action: #selector(closeTheRoom), for: .touchUpInside)
        
        matchLoadingView.startAnimating()

        ref = Database.database().reference()
        
        matchRoomRef = ref.child("Match Room").child(type).child(matchRoomId)
        
        self.fetchMatchRoomDataManager.delegate = self
        
        let url = URL(string: myPhotoURl)
        
        if myGender == "male" {
            
            myImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "boy"), options: .refreshCached, completed: nil)
            myNameLabel.text = myName
            myTextView.text = myGeetingText
            
        } else {
            
            myImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "girl"), options: .refreshCached, completed: nil)
            myNameLabel.text = myName
            myTextView.text = myGeetingText
            
        }
        
        observerIsAnyoneDecline()

        if isARoomOwner == true {

            ownerSuccessManager.delegate = self
            
            matchRoomRef.child("locked").observe(.value, with: { (snapshot) in
                
                if self.runTime == 1 {
                
                self.fetchMatchRoomDataManager.getRoomData(by: self.matchRoomRef, isRoomowner: self.isARoomOwner, type: self.type)
                
                self.ownerSnapshot = snapshot
                    
                } else {
                    
                    self.runTime += 1
                    
                }
                
            })
            
        } else {
            
            //取得connection room id
            matchRoomRef.child("Connection").observe(.value, with: { (snapshot) in
                
                if self.runTime == 1 {

                guard let connectionRoomId = snapshot.value as? String else { return }
    
                self.ref.child("Match Room").child(self.type).child(self.matchRoomId).child("Connection").removeAllObservers()
                
                self.fetchMatchRoomDataManager.getRoomData(by: self.matchRoomRef, isRoomowner: self.isARoomOwner, type: self.type)
                    
                } else {
                    
                    self.runTime += 1
                    
                }
                
            })
        }
    }
    
    func manager(_ manager: OwnerMatchSuccessManager, matchSuccess: String) {
        
        acceptButton.isHidden = false
        
        acceptButton.addTarget(self, action: #selector(goToChatRoom), for: .touchUpInside)
        
    }

    func manager(_ manager: FetchMatchRoomDataManager, matchRoomData: MatchPeopleInfo) {
        
        oppositePeopleNameLabel.text = matchRoomData.oppositePeopleName
        
        oppositePeopleInfoTextView.text = matchRoomData.oppositePeopleText
        
        oppositePeopleImageView = matchRoomData.oppositePeopleImage
        
        oppositePeopleImageView.contentMode = .scaleAspectFit
        
        oppositePeopleImageView.layer.borderWidth = 2
        
        if matchRoomData.oppositePeopleGender == "male" {
            
            oppositePeopleImageView.layer.borderColor = UIColor.asiSeaBlue.cgColor
            
        } else {
            
            oppositePeopleImageView.layer.borderColor = UIColor.asiPale.cgColor
            
        }
        
        if isARoomOwner == true {
            
            // 建立房間
            self.ownerSuccessManager.matchSuccess(matchRoomRef: self.matchRoomRef,
                                                  ref: self.ref,
                                                  type: self.type,
                                                  matchRoomId: self.matchRoomId,
                                                  snapshot: self.ownerSnapshot)

            matchRoomRef.child("locked").removeAllObservers()
            
        } else {

            acceptButton.isHidden = false
            
            acceptButton.addTarget(self, action: #selector(goToChatRoom), for: .touchUpInside)
            
        }
        
    }
    
    func manager(_ manager: FetchMatchRoomDataManager, didFail error: String) {
        
            print(error)
        
    }
    
    func goToChatRoom(sender: UIButton) {
        
         self.performSegue(withIdentifier: "matchSuccess", sender: nil)
        
    }
    
    func closeTheRoom() {
        
        self.matchRoomRef.child("locked").setValue(true)
        self.matchRoomRef.child("finished").setValue(true)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    func observerIsAnyoneDecline() {
        
        matchRoomRef.child("finished").observe(.value, with: { (snapshot) in
            
            if self.runTime == 1 {
                
                self.navigationController?.popViewController(animated: true)
                
            }
            
        })

        
    }
}
