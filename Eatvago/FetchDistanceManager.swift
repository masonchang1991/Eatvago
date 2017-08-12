//
//  FetchDistance.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/1.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import Alamofire
import UIKit
import GooglePlaces

protocol FetchDistanceDelegate: class {
    func manager(_ manager: FetchDistanceManager, didGet nearLocationsWithDistance: [Location])
    func manager(_ manager: FetchDistanceManager, didFailWith error: Error)
}
class FetchDistanceManager {
    
    weak var delegate: FetchDistanceDelegate?
    
    var locations: [Location] = []
    
    func fetchDistance(myLocation: CLLocation, nearLocations: [Location]) {
        
        var fetchCount = 0
        locations = []
        
        for nearLocation in nearLocations {
            
            let urlStringForDistance = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=\(myLocation.coordinate.latitude),\(myLocation.coordinate.longitude)&destinations=\(nearLocation.latitude),\(nearLocation.longitude)&key=\(googleMapDistanceMatrixAPIKey)"
            
            Alamofire.request(urlStringForDistance).responseJSON { (response) in
                
                print(urlStringForDistance)
                
                var location = nearLocation
                
                let jsonOfDistance = response.result.value
                
                guard let localJsonOfDistance = jsonOfDistance as? [String: Any] else {
                    self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                    return
                }
                
                guard let rowsOfElements = localJsonOfDistance["rows"] as? [[String:Any]] else {
                    self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                    return
                }
                
                print(rowsOfElements.description)
                
                
//                let rowOfElement = rowsOfElements[0]
//                guard let elements = rowOfElement["elements"] as? [[String:Any]] else {
//                    self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
//                    return
//                }
//                let element = elements[0]
//                
//                guard let distance = element["distance"] as? [String: Any],
//                    let duration = element["duration"] as? [String:Any] else {
//                        self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
//                        return
//                }
//                
//                guard let distanceText = distance["text"] as? String,
//                    let durationText = duration["text"] as? String else {
//                        self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
//                        return
//                }
//                
//                location.distanceText = distanceText
//                location.durationText = durationText
//                
                self.locations.append(location)
                
                //直到fetch到最後一個才delegate回去
                fetchCount += 1
                if fetchCount == nearLocations.count {
                    self.delegate?.manager(self, didGet: self.locations)
                }
                
                
            }
            
        }
        
    }

}
