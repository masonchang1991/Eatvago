//
//  FetchLocationsDelegateFunction.swift
//  
//
//  Created by Ｍason Chang on 2017/8/5.
//
//

import UIKit

extension NearbyViewController: FetchLocationDelegate {
    
    func manager(_ manager: FetchNearbyLocationManager, didGet nearLocations: [Location], nextPageToken: String?) {
        
        fetchDistanceManager.fetchDistance(myLocation: self.currentLocation, nearLocations: nearLocations)
        
        if nextPageToken != nil && nextPageToken != "" {
            
            if let pageToken = nextPageToken {
                
                self.nextPageToken = pageToken
            
            }
            
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
