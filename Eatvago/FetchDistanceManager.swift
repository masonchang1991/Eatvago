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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                
                let urlStringForDistance = "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=\(myLocation.coordinate.latitude),\(myLocation.coordinate.longitude)&destinations=\(nearLocation.latitude),\(nearLocation.longitude)&mode=walking&key=\(googleMapDistanceMatrixAPIKey)"
                
                Alamofire.request(urlStringForDistance).responseJSON { (response) in
                    
                    print(urlStringForDistance)
                    
                    var location = nearLocation
                    
                    let jsonOfDistance = response.result.value
                    
                    guard
                        let localJsonOfDistance = jsonOfDistance as? [String: Any],
                        let rowsOfElements = localJsonOfDistance["rows"] as? [[String:Any]],
                        let elements = rowsOfElements[0]["elements"] as? [[String:Any]],
                        let distance = elements[0]["distance"] as? [String: Any],
                        let duration = elements[0]["duration"] as? [String:Any],
                        let distanceText = distance["text"] as? String,
                        let durationText = duration["text"] as? String else {
                        self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                        return
                    }

                    location.distanceText = distanceText
                    
                    location.durationText = durationText

                    self.locations.append(location)
                    
                    //直到fetch到最後一個才delegate回去
                    fetchCount += 1
                    
                    if fetchCount == nearLocations.count {
                        
                        self.delegate?.manager(self, didGet: self.locations)
                        
                    }
                }
            })
        }
        
    }

}
