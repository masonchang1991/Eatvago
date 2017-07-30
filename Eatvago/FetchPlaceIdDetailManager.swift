//
//  FetchPlaceIdDetailManager.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/7/30.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Alamofire

protocol FetchPlaceIdDetailDelegate: class {
    func manager(_ manager: FetchPlaceIdDetailManager, searchBy placeId: String, didGet locationWithDetail: Location)
    func manager(_ manager: FetchPlaceIdDetailManager, didFailWith error: Error)
}


class FetchPlaceIdDetailManager {
    
     weak var delegate: FetchPlaceIdDetailDelegate?
    
    func requestPlaceIdDetail(placeId: String, locationWithoutDetail: Location) {
        
        var location = locationWithoutDetail
        
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=\(googleMapAPIKey)"
        
        Alamofire.request(urlString).responseJSON { (response) in
            
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
                guard let phoneNumber = result["formatted_phone_number"] as? String else{
                    return
                }
                formattedPhoneNumber = phoneNumber
            }
            var website = ""
            if result["website"] != nil {
                guard let web = result["website"] as? String else {
                    return
                }
                website = web
            }
            guard let openingHours = result["opening_hours"] as? [String: Any],
                    let reviews = result["reviews"] as? [[String:Any]] else {
                return
            }
            
            for review in reviews {
                if review["text"] != nil {
                    guard let text = review["text"] as? String else {
                        return
                    }
                    location.reviewsText.append(text)
                } else {
                    
                }
            }

            //剩餘解optional的放入location
            location.formattedPhoneNumber = formattedPhoneNumber
            location.openingHours = openingHours
            location.website = website
            
            self.delegate?.manager(self, searchBy: placeId, didGet: location)

        }
        
        
    }
    
    
}
