//
//  MatchFetchLocationDelegate.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/12.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit

extension MatchSuccessViewController: FetchLocationDelegate {
    
    func manager(_ manager: FetchNearbyLocationManager, didGet nearLocations: [Location], nextPageToken: String?) {
        
        print(nearLocations.count)
        
        let myLocation = self.myLocation
        
        fetchDistanceManager.fetchDistance(myLocation: myLocation,
                                           nearLocations: nearLocations)
        
        if nextPageToken != nil {
            
            guard let pageToken = nextPageToken else {
                return
            }
            
            self.nextPageToken = pageToken
            
        } else {
            
            print("there is no other page")
            
        }
    }
    
    func manager(_ manager: FetchNearbyLocationManager, didFailWith error: Error) {
        
        print(error)
        
    }
    
    func manager(_ manager: FetchNearbyLocationManager, didFailWith noDataIn: String) {
        
        if locations.count == 0 {
            
            locationManager.stopUpdatingLocation()
            
            locationManager.startUpdatingLocation()
            
        }
    }
    
}
