//
//  GetPhotoFunction.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/13.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension NearbyViewController: UIImagePickerControllerDelegate, UploadOrDownLoadUserPhotoDelegate {
    
    func getUserCamera() {
        
        let picker: UIImagePickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            picker.sourceType = UIImagePickerControllerSourceType.camera
            
            picker.allowsEditing = true // 可對照片作編輯
            
            picker.delegate = self
            
            self.userProfileAlertView.present(picker, animated: true, completion: nil)
            
        } else {
            
            // 建立一個提示框
            let alertController = UIAlertController(
                title: "Sorry",
                message: "Your camera didn't work",
                preferredStyle: .alert)
            
            // 建立[ok]按鈕
            let okAction = UIAlertAction(
                title: "ok",
                style: .default,
                handler: nil)
            alertController.addAction(okAction)
            self.userProfileAlertView.present(
                alertController,
                animated: true,
                completion: nil)
            
        }
        
    }
    
    func getUserPhoto() {
        
        let picker: UIImagePickerController = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            picker.allowsEditing = true
            
            picker.delegate = self
            
            self.userProfileAlertView.present(picker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        picker.dismiss(animated: true, completion: nil) //關掉相簿
        self.userPhotoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage //將選取圖片存入我那個imageview中
        
        if let image = self.userPhotoImageView.image {
            
            //set照片長寬
            self.userPhotoImageView.frame.size =
                CGSize(width: self.userPhotoImageView.frame.width,
                       height: self.userPhotoImageView.frame.height)
            //放照片啦
            self.userPhotoImageView.image = image
            
            self.userPhotoImageView.contentMode = .scaleAspectFill
            
            self.uploadOrDownLoadUserPhotoManager.uploadUserPhoto(userPhoto: image)
            
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func manager(_ manager: UploadOrDownLoadUserPhotoManager, uploadSuccessNotion successNotion: String, photoURL: String) {
        
        print(successNotion)
        
        tabBarC?.userPhotoURLString = photoURL
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        
    }
    
    func manager(_ manager: UploadOrDownLoadUserPhotoManager, errorDescription: Error) {
        
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()

        self.uploadOrDownLoadUserPhotoManager.downLoadUserPhoto()
        
    }
    
    func manager(_ manager: UploadOrDownLoadUserPhotoManager, downloadImageURL: URL) {

        tabBarC?.userPhotoURLString = downloadImageURL.absoluteString

        DispatchQueue.main.async {
            
            self.userPhotoImageView.sd_setImage(with: downloadImageURL, completed: nil)
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
        }
        
    }
    
}
