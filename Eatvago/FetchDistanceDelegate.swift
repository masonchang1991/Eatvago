//
//  FetchDistanceDelegateFunction.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/5.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

extension NearbyViewController: FetchDistanceDelegate {
    
    func manager(_ manager: FetchDistanceManager, didGet nearLocationsWithDistance: [Location]) {
        
        //每個地點delegate去獲取詳細資訊
        for location in nearLocationsWithDistance {
            //用字典防止重複append
            if nearbyLocationDictionary["\(location.placeId)"] == nil {
                
                let coordinates = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                
                let marker = GMSMarker(position: coordinates)
                
                marker.title = location.name
                
                marker.map = self.googleMapView
                
                //self.googleMapView.animate(toLocation: coordinates)
                
                nearbyLocationDictionary["\(location.placeId)"] = location
                
                self.locations.append(location)
                
                self.fetchLocationImageManager.loadFirstPhotoForLocation(placeID: location.placeId, indexPathRow: (self.locations.count - 1))
                
            } else {
                
                print("已經出現過", location.name)
                
            }
        }
        
        self.mapTableView.reloadData()
        
        if self.lastPageToken != "" && self.lastPageToken == self.nextPageToken {
            
            return
            
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) {
            
            self.lastPageToken = self.nextPageToken
            
            self.fetchNearbyLocationManager.fetchRequestHandler(urlString: "", nextPageToken: self.nextPageToken)
            
        }
        
    }
    
    func manager(_ manager: FetchDistanceManager, didFailWith error: Error) {
        
    }
    
}
