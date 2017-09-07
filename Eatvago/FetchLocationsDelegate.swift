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
        
        print(nearLocations.count)
        
        let myLocation = currentLocation
        
        fetchDistanceManager.fetchDistance(myLocation: myLocation, nearLocations: nearLocations)
        
        if nextPageToken != nil && nextPageToken != "" {
            
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
