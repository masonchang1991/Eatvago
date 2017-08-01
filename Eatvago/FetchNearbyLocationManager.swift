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
    func manager(_ manager: FetchNearbyLocationManager, didGet nearLocations: [Location], nextPageToken: String?)
    func manager(_ manager: FetchNearbyLocationManager, didFailWith error: Error)
    func manager(_ manager: FetchNearbyLocationManager, didFailWith noDataIn: String)
}

enum FetchError: Error {
    case invalidFormatted
}

class FetchNearbyLocationManager {
    
    weak var delegate: FetchLocationDelegate?
    
    //獲取地圖資訊的陣列
    var locations: [Location] = []
    
    func requestNearbyLocation(coordinate: CLLocationCoordinate2D, radius: Double) {

        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&type=restaurant&keyword=&key=\(googleMapAPIKey)"

        print(urlString)

        fetchRequestHandler(urlString: urlString)
    }
    
    func fetchRequestHandler(urlString: String) {
        
        locations = []
        //清空之前的陣列

        Alamofire.request(urlString).responseJSON { (response) in

            let json = response.result.value
            guard let localJson = json as? [String: Any] else {
                self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                return
            }
            guard let results = localJson["results"] as? [[String: Any]],
                let pageToken = localJson["next_page_token"] as? String? else {
                    self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                    return
            }
            print("next", pageToken)
            if results.count == 0 {
                self.delegate?.manager(self, didFailWith: "請重新呼叫LocationManager")
                return
            }
            
            for result in results {
                // 不是所有都有priceLevel, rating所以特別拿出來
                // priceLevel = -1.0 代表此資料沒提供priceLevel
                var priceLevel = -1.0
                if result["price_level"] != nil {
                    guard let plevel = result["price_level"] as? Double else {
                        self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)

                        return
                    }
                    priceLevel = plevel
                }
                var rating = -1.0
                if result["rating"] != nil {
                    guard let rlevel = result["rating"] as? Double else {
                        self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)

                        return
                    }
                    rating = rlevel
                }
                
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
                guard let latitude = location["lat"] as? CLLocationDegrees,
                    let longitude = location["lng"] as? CLLocationDegrees else {
                        self.delegate?.manager(self, didFailWith: FetchError.invalidFormatted)
                        return
                }
                let locationData = Location(latitude: latitude, longitude: longitude, name: name, id: id, placeId: placeId, types: types, priceLevel: priceLevel, rating: rating)
                
                self.locations.append(locationData)
            }
            self.delegate?.manager(self, didGet: self.locations, nextPageToken: pageToken)
                        
        }
    }
}
