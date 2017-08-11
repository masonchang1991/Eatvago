//
//  LoadingMatchViewController.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/10.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Firebase

class LoadingMatchViewController: UIViewController, OwnerMatchSuccessDelegate {

    @IBOutlet weak var test: UILabel!
    
    var matchRoomId = ""
    
    var type = ""
    
    var ref: DatabaseReference = DatabaseReference()
    
    var ownerSuccessManager = OwnerMatchSuccessManager()
    
    var isARoomOwner: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        let matchRoomRef = ref.child("Match Room").child(type).child(matchRoomId)

        if isARoomOwner == true {
            
            ownerSuccessManager.delegate = self
            
            matchRoomRef.child("locked").observe(.value, with: { (snapshot) in
                
                self.ownerSuccessManager.matchSuccess(matchRoomRef: matchRoomRef,
                                                      ref: self.ref,
                                                      type: self.type,
                                                      matchRoomId: self.matchRoomId,
                                                      snapshot: snapshot)
                
            })
            
        } else {
            
            self.ref.child("Match Room").child(type).child(matchRoomId).child("Connection").observe(.value, with: { (snapshot) in

                guard let connectionRoomId = snapshot.value as? String else { return }
    
                self.ref.child("Match Room").child(self.type).child(self.matchRoomId).child("Connection").removeAllObservers()
                
                self.performSegue(withIdentifier: "matchSuccess", sender: nil)
                
            })
        }
    }
    
    func manager(_ manager: OwnerMatchSuccessManager, matchSuccess: String) {

        self.performSegue(withIdentifier: "matchSuccess", sender: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
