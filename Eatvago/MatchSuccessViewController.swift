//
//  MatchSuccessViewController.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/11.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Firebase


class MatchSuccessViewController: UIViewController {
    
    var matchRoomRef = DatabaseReference()
    
    var matchSuccessRoomRef = DatabaseReference()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        matchRoomRef.child("isClosed").observe(.value, with: { (snapshot) in
            
            guard let isClosed = snapshot.value as? Bool else {
                return
            }
            
            if isClosed == true {
                
                //跳出alert
                // 建立一個提示框
                let alertController = UIAlertController(
                    title: "Sorry",
                    message: "You have been declined",
                    preferredStyle: .alert)
                
                // 建立[OK]按鈕
                let okAction = UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.default) { (_: UIAlertAction!) -> Void in
          
                        self.performSegue(withIdentifier: "goBackToMain", sender: nil)
                        
                    }
                alertController.addAction(okAction)
                self.present(
                    alertController,
                    animated: true,
                    completion: nil)

            }
            
        })


        
        
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
