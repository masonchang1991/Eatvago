//
//  UploadUserPhotoManager.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/13.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

protocol UploadUserPhotoDelegate:class {
    
    func manager(_ manager: UploadUserPhotoManager, successNotion: String)
    
    func manager(_ manager: UploadUserPhotoManager, errorDescription: String?)
    
    
}


class UploadUserPhotoManager {
    
    weak var delegate: UploadUserPhotoDelegate?
    
    
    func uploadUserPhoto(userPhoto: UIImage) {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let reference: DatabaseReference! = Database.database().reference().child("UserAccount").child(userID).child("UserPhotoURL")
        
        let storageRef = Storage.storage().reference().child("UserAccount").child(userID).child("UserPhoto")
        
        if let uploadData = UIImagePNGRepresentation(userPhoto) {
            
            
            storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
                
                if error != nil {
                    
                    self.delegate?.manager(self, errorDescription: error?.localizedDescription)
                    return
                    
                }
                
                
                if let uploadImageUrl = data?.downloadURL()?.absoluteString {
                    
                    reference.setValue(uploadImageUrl)
                    self.delegate?.manager(self, successNotion: "uploadImage Success")
                    
                }
                
                
            })
            
        }
    }
    
}
