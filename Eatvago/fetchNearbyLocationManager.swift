//
//  fetchNearbyLocationManager.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/7/28.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces

protocol FetchLocationDelegate: class {
    func manager(_ manager: FetchNearbyLocationManager, didGet locations: [Location])
    func manager(_ manager: FetchNearbyLocationManager, didFailWith error: Error)
}

enum FetchError: Error {
    case invalidFormatted
}


class FetchNearbyLocationManager {
    
    weak var delegate: FetchLocationDelegate?
    
    var locations: [Location] = []
    var nextPageToken = ""
    
    func requestNearbyLocation(coordinate: CLLocationCoordinate2D, radius: Double) {
        
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&type=restaurant&key=\(googleMapAPIKey)"
        print(urlString)
        Alamofire.request(urlString).responseJSON { (response) in
            debugPrint(response)
            let json = response.result.value
            guard let localJson = json as? [String: Any] else {
                self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                return
            }
            guard let results = localJson["results"] as? [[String: Any]],
                let pageToken = localJson["next_page_token"] as? String else {
                    self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                    return
            }
            self.nextPageToken = pageToken
            
            for result in results {
                // 不是所有都有opening_hours所以特別拿出來
                let openingHours = result["opening_hours"] as? [String: Any] ?? nil
                
                guard let geometry = result["geometry"] as? [String:Any],
                    let id = result["id"] as? String,
                    let name = result["name"] as? String,
                    let placeId = result["place_id"] as? String,
                    let types = result["types"] as? [String] else {
                        
                        self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                        return
                }
                guard let location = geometry["location"] as? [String:Any] else {
                    self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                    return
                }
                
                print(location)
                
                guard let latitude = location["lat"] as? CLLocationDegrees,
                    let longitude = location["lng"] as? CLLocationDegrees else {
                        self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                        return
                }
                
                let locationData = Location(latitude: latitude, longitude: longitude, name: name, id: id, openingHours: openingHours, placeId: placeId, types: types)
                
                self.locations.append(locationData)
            }
            self.delegate?.manager(self, didGet: self.locations)
            
            
        }
        
    }
    
}
