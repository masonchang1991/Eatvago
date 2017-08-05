//
//  FetchPlaceImageManager.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/5.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import GooglePlaces


protocol FetchLocationImageDelegate: class {
    
    func manager(_ manager: FetchLocationImageManager, didGet locationImage: UIImage, at indexPathRow: Int)
    
    func manager(_ manager: FetchLocationImageManager, didFailWith error: Error)
    
}

class FetchLocationImageManager {

    weak var delegate: FetchLocationImageDelegate?

    //讀取圖片func
    func loadFirstPhotoForLocation(placeID: String, indexPathRow: Int) {

        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
                
            } else {
                
                if let firstPhoto = photos?.results.first {
                    
                    self.loadImageForMetadata(photoMetadata: firstPhoto, indexPathRow: indexPathRow)
                    
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata, indexPathRow: Int) {
        
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            
            (photo, error) -> Void in
            
            if let error = error {
                // TODO: handle the error.
                
                self.delegate?.manager(self, didFailWith: error)
                
                print("Error: \(error.localizedDescription)")
                
            } else {
                
                guard let locationImage = photo else {
                    return
                }
                
                self.delegate?.manager(self, didGet: locationImage, at: indexPathRow)

            }
        })
    }
}




