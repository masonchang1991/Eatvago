//
//  NearByUserPhotoFunction.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/13.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit


extension NearbyViewController: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    
    func fetchUserPhotoFromFireBase() {
        
        
        
        
    }
    
    
    
    
    
    
    func stepUpUserPhotoGesture() {
        
         let tap = UITapGestureRecognizer(target: self, action: #selector(choosePhotoOrCamera))
        
         self.userPhotoImageView.addGestureRecognizer(tap)
        
         self.userPhotoImageView.isUserInteractionEnabled = true
        
        
    }
    
    func choosePhotoOrCamera() {
        
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "Note",
            message: "Choose a way to add photo",
            preferredStyle: .alert)
        
        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(
            title: "cancel",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)
        
        // 建立[相簿]按鈕
        let photoAction = UIAlertAction(
            title: "Album",
            style: .default) { (_: UIAlertAction!) -> Void in
                
                self.getUserPhoto()
        }
        
        alertController.addAction(photoAction)
        
        // 建立[相機]按鈕
        let cameraAction = UIAlertAction(
            title: "Camera",
            style: .default) { (_: UIAlertAction!) -> Void in
                
                self.getUserCamera()
                
        }
        alertController.addAction(cameraAction)
        self.present(
            alertController,
            animated: true,
            completion: nil)
        
    }

    
    
    
    
    
    
}
