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
    func manager(_ manager: FetchPlaceIdDetailManager, searchBy placeId: String, didGet locationWithDetail: Location)
    func manager(_ manager: FetchPlaceIdDetailManager, didFailWith error: Error)
}

class FetchPlaceIdDetailManager {
    
     weak var delegate: FetchPlaceIdDetailDelegate?
    
    func requestPlaceIdDetail(placeId: String, locationWithoutDetail: Location, myLocation: CLLocation) {
        
        var location = locationWithoutDetail
        
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=\(googleMapAPIKey)"
        
        var i = 0
        
        
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
                    location.reviewsText.append(text)
                } else {
                    
                }
            }
            print("00")

            //剩餘解optional的放入location
            location.formattedPhoneNumber = formattedPhoneNumber
            location.openingHours = openingHours
            location.website = website
            location.photoReference = photoReference
            
            
            let urlStringForDistance = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=\(myLocation.coordinate.latitude),\(myLocation.coordinate.longitude)&destinations=\(locationWithoutDetail.latitude),\(locationWithoutDetail.longitude)&key=\(googleMapDistanceMatrixAPIKey)"
            
            Alamofire.request(urlStringForDistance).responseJSON { (response) in
                
                let jsonOfDistance = response.result.value
                
                guard let localJsonOfDistance = jsonOfDistance as? [String: Any] else {
                    self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                    return
                }
                
                guard let rowsOfElements = localJsonOfDistance["rows"] as? [[String:Any]] else {
                    self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                    return
                }
                let rowOfElement = rowsOfElements[0]
                guard let elements = rowOfElement["elements"] as? [[String:Any]] else {
                    self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                    return
                }
                let element = elements[0]
                
                guard let distance = element["distance"] as? [String: Any],
                        let duration = element["duration"] as? [String:Any] else {
                        self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                        return
                }
                
                guard let distanceText = distance["text"] as? String,
                        let durationText = duration["text"] as? String else {
                        self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                        return
                }
                
                location.distanceText = distanceText
                location.durationText = durationText
                
                self.delegate?.manager(self, searchBy: placeId, didGet: location)
                
            }

        }
        
    }
    
}

