//
//  FetchLocationImageDelegate.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/5.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit

extension NearbyViewController: FetchLocationImageDelegate {
    
    func manager(_ manager: FetchLocationImageManager, didGet locationImage: UIImage, at indexPathRow: Int) {
        
        DispatchQueue.main.async {
            if self.locations.count > indexPathRow {
                
            self.locations[indexPathRow].photo = locationImage
            
            self.storeImagePagerView.reloadInputViews()
                
            }
        }
        
    }
    
    func manager(_ manager: FetchLocationImageManager, didFailWith error: Error) {
        
    }
    
}
