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
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var matchRoomId = ""
    
    var type = ""
    
    var myName = ""
    
    var myGeetingText = ""
    
    var myPhotoURl = ""
    
    var myGender = ""
    
    var myPhotoImage = UIImage()
    
    var ref: DatabaseReference = DatabaseReference()
    
    var ownerSuccessManager = OwnerMatchSuccessManager()
    
    var fetchMatchRoomDataManager = FetchMatchRoomDataManager()
    
    var matchRoomRef = DatabaseReference()
    
    var matchSuccessRoomRef = DatabaseReference()
    
    var ownerSnapshot = DataSnapshot()
    
    //將connectionRoomID拿出 傳到match success viewcontroller
    
    var connectionId = "noRoomNow"
    
    var isARoomOwner: Bool = true
    
    var ifAcceptMatch: Bool = false
    
    var window: UIWindow?
    
    var ifLeaveByAccept = false
    
    // 讓observer 第一次設定時不要run
    var runTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        acceptButton.isHidden = true
        
        declineButton.addTarget(self, action: #selector(closeTheRoom), for: .touchUpInside)
        
        matchLoadingView.startAnimating()

        ref = Database.database().reference()
        
        matchRoomRef = ref.child("Match Room").child(type).child(matchRoomId)
        
        self.fetchMatchRoomDataManager.delegate = self

        setLayout()
                
        observerIsAnyoneDecline()

        if isARoomOwner == true {

            ownerSuccessManager.delegate = self
            
            matchRoomRef.child("isLocked").observe(.value, with: { (snapshot) in
                
                if self.runTime == 1 {
                
                self.fetchMatchRoomDataManager.getRoomData(by: self.matchRoomRef,
                                                           isRoomowner: self.isARoomOwner,
                                                           type: self.type)
                
                self.ownerSnapshot = snapshot
                    
                self.matchRoomRef.child("isLocked").removeAllObservers()
                    
                } else {
                    
                    self.runTime += 1
                    
                }
            })
            
        } else {
            
            //取得connection room id
            matchRoomRef.child("Connection").observe(.value, with: { (snapshot) in
                
                if self.runTime == 1 {

                guard let connectionRoomId = snapshot.value as? String else { return }
                    
                self.matchSuccessRoomRef = self.ref.child("Connection").child(connectionRoomId)
                    
                self.connectionId = connectionRoomId
    
                self.ref.child("Match Room").child(self.type).child(self.matchRoomId).child("Connection").removeAllObservers()
                
                self.fetchMatchRoomDataManager.getRoomData(by: self.matchRoomRef,
                                                           isRoomowner: self.isARoomOwner,
                                                           type: self.type)
                    
                } else {
                    
                    self.runTime += 1
                    
                }
                
            })
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
            self.ref.removeAllObservers()
        
            if ifLeaveByAccept == true {
                
                // do nothing
                
            } else {
                
                closeTheRoom()
                
            }
        
    }
    
    func manager(_ manager: OwnerMatchSuccessManager, matchSuccessRoomRef: DatabaseReference, connectionRoomId: String) {
        
        self.matchSuccessRoomRef = matchSuccessRoomRef
        
        self.connectionId = connectionRoomId
        
        acceptButton.isHidden = false
        
        acceptButton.addTarget(self, action: #selector(goToChatRoom), for: .touchUpInside)
        
    }

    func manager(_ manager: FetchMatchRoomDataManager, matchRoomData: MatchPeopleInfo) {
        
        oppositePeopleNameLabel.text = matchRoomData.oppositePeopleName
        
        oppositePeopleInfoTextView.text = matchRoomData.oppositePeopleText
        
        guard let photoURL = matchRoomData.oppositePeoplePhotoURL else { return }
        
        let url = URL(string: photoURL)

        oppositePeopleImageView.sd_setImage(with: url, completed: nil)
        
        oppositePeopleImageView.sd_setImage(with: url,
                                            placeholderImage: UIImage(named: "UserDefaultIconForMatch"),
                                            options: SDWebImageOptions.retryFailed, completed: nil)
        
        oppositePeopleImageView.contentMode = .scaleAspectFill
        
        oppositePeopleImageView.layer.borderWidth = 1
        
        oppositePeopleImageView.layer.cornerRadius = oppositePeopleImageView.frame.width / 2
        
        oppositePeopleImageView.clipsToBounds = true
        
        if matchRoomData.oppositePeopleGender == "man" {
            
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

            matchRoomRef.child("isLocked").removeAllObservers()
            
        } else {

            acceptButton.isHidden = false
            
            acceptButton.addTarget(self, action: #selector(goToChatRoom), for: .touchUpInside)
            
        }
        
    }
    
    func manager(_ manager: FetchMatchRoomDataManager, didFail error: String) {
        
            print(error)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let matchSuccessVC = segue.destination as? MatchSuccessViewController ?? MatchSuccessViewController()
        
        matchSuccessVC.matchRoomRef = self.matchRoomRef
        
        matchSuccessVC.matchSuccessRoomRef = self.matchSuccessRoomRef
        
        matchSuccessVC.myName = self.myName
        
        matchSuccessVC.myPhotoImageView = self.myImageView
        
        matchSuccessVC.oppositePeopleName = self.oppositePeopleNameLabel.text ?? ""
        
        matchSuccessVC.oppositePeopleImageView = self.oppositePeopleImageView
        
        matchSuccessVC.type = self.type
        
        matchSuccessVC.isRoomOwner = self.isARoomOwner
        
        matchSuccessVC.connectionRoomId = connectionId
        
        matchSuccessVC.oppositePeoplePhoto = self.oppositePeopleImageView.image ?? UIImage()
        
    }
    
    func goToChatRoom(sender: UIButton) {
        
        ifAcceptMatch = true
        
        ifLeaveByAccept = true
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ref.child("UserHistory").child(uid).child(connectionId).setValue(connectionId)
        
        //swiftlint:disable force_cast
        let matchSuccessVC = self.storyboard?.instantiateViewController(withIdentifier: "matchSuccess") as! MatchSuccessViewController
        
        matchSuccessVC.matchRoomRef = self.matchRoomRef
        
        matchSuccessVC.matchSuccessRoomRef = self.matchSuccessRoomRef
        
        matchSuccessVC.myName = self.myName
        
        matchSuccessVC.myPhotoImageView = self.myImageView
        
        matchSuccessVC.oppositePeopleName = self.oppositePeopleNameLabel.text ?? ""
        
        matchSuccessVC.oppositePeopleImageView = self.oppositePeopleImageView
        
        matchSuccessVC.type = self.type
        
        matchSuccessVC.isRoomOwner = self.isARoomOwner
        
        matchSuccessVC.connectionRoomId = self.connectionId
        
        matchSuccessVC.oppositePeoplePhoto = self.oppositePeopleImageView.image ?? UIImage()
        
        self.present(matchSuccessVC, animated: false, completion: nil)
        
        self.navigationController?.popToRootViewController(animated: false)
        
        Analytics.logEvent("Loading_accept_goToChatRoom", parameters: nil)

    }
    
    func closeTheRoom() {
        
        self.matchRoomRef.child("isLocked").setValue(true)
        
        self.matchRoomRef.child("isClosed").setValue(true)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        self.ref.child("UserHistory").child(uid).child(self.connectionId).removeValue()
        
        Analytics.logEvent("Loading_closeTheRoom", parameters: nil)
        
    }
    
    func observerIsAnyoneDecline() {
        
        matchRoomRef.child("isClosed").observe(.value, with: { (_) in
            
            if self.runTime == 1 {
                
                self.navigationController?.popViewController(animated: true)
                
                self.matchRoomRef.child("isClosed").removeAllObservers()
                
                Analytics.logEvent("Loading_observerIsAnyoneDecline", parameters: nil)
                
            }
            
        })
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
    }
    
}
