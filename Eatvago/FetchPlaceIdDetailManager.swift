//
//  FetchPlaceIdDetailManager.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/7/30.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps

protocol FetchPlaceIdDetailDelegate: class {
    func manager(_ manager: FetchPlaceIdDetailManager, searchBy placeId: String, didGet locationWithDetail: Location, senderTag: Int)
    func manager(_ manager: FetchPlaceIdDetailManager, didFailWith error: Error)
}

class FetchPlaceIdDetailManager {
    
     weak var delegate: FetchPlaceIdDetailDelegate?
    
    func requestPlaceIdDetail(locationsWithoutDetail: Location, senderTag: Int) {
            
            let placeId = locationsWithoutDetail .placeId
            
            let urlString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=\(googleMapAPIKey[0])"
            
            Alamofire.request(urlString).responseJSON { (response) in
                
                var locationWithDetail = locationsWithoutDetail
                
                let json = response.result.value
                guard let localJson = json as? [String: Any] else {
                    self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                    return
                }
                
                guard let result = localJson["result"] as? [String: Any] else {
                    self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                    return
                }
                // 電話號碼,網址可能不提供 所以有電話號碼才用guard let
                var formattedPhoneNumber = ""
                
                if result["formatted_phone_number"] != nil {
                    guard let phoneNumber = result["formatted_phone_number"] as? String else {
                        self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                        return
                    }
                    formattedPhoneNumber = phoneNumber
                }
                var website = ""
                if result["website"] != nil {
                    guard let web = result["website"] as? String else {
                        self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                        return
                    }
                    website = web
                }
                guard let openingHours = result["opening_hours"] as? [String: Any],
                    let reviews = result["reviews"] as? [[String:Any]] else {
                        self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                        return
                }
                
                guard let photos = result["photos"] as? [[String:Any]] else {
                    self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                    return
                }
                let photo = photos[0]
                
                guard let photoReference = photo["photo_reference"] as? String else {
                    self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                    return
                }
                for review in reviews {
                    if review["text"] != nil {
                        guard let text = review["text"] as? String else {
                            self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                            return
                        }
                        locationWithDetail.reviewsText.append(text)
                    } else {
                        
                    }
                }
                
                //剩餘解optional的放入location
                locationWithDetail.formattedPhoneNumber = formattedPhoneNumber
                locationWithDetail.openingHours = openingHours
                locationWithDetail.website = website
                locationWithDetail.photoReference = photoReference
                self.delegate?.manager(self, searchBy: placeId, didGet: locationWithDetail, senderTag: senderTag)
            
        }
    }
    
}
