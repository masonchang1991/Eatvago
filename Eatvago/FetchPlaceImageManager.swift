//
//  FetchPlaceImageManager.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/7/31.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import SDWebImage

protocol FetchPlaceImageDelegate: class {
    func manager(_ manager: FetchPlaceImageManager, fetch image: UIImageView, imageOfIndexPathRow: Int)
    func manager(_ manager: FetchPlaceImageManager, didFailWith error: Error)
}

class FetchPlaceImageManager {
    
    weak var delegate: FetchPlaceImageDelegate?
    
    func fetchImage(locationPhotoReference photoReference: String, imageOfIndexPathRow: Int) {
        
        //下載圖片
        if photoReference == "" {
            return
        }
        
            let requestImgUrl = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photoreference=\(photoReference)&key=\(googleMapAPIKey)")
            
            
            guard let url = requestImgUrl else {
                return
            }
            
            print(url)
            
            let img = UIImageView()
            
            img.sd_setImage(with: url)
            
            self.delegate?.manager(self, fetch: img, imageOfIndexPathRow: imageOfIndexPathRow)

    }
}
