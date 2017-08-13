//
//  FetchMatchSuccessRoomDataDelegate.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/12.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces


extension MatchSuccessViewController: FetchMatchSuccessRoomDataDelegate {

    func manager(_ manager: FetchMatchSuccessRoomDataManager, didGet successRoomData: MatchSuccessRoom) {
        
        if type == "Any" {
            type = ""
        }
        
        self.fetchNearbyLocationManager.requestNearbyLocation(coordinate: successRoomData.centerLocation, radius: 1000, keywordText: type)
        
        // 將使用者座標釘上
        if isRoomOwner == true {
            
            self.myLocation = CLLocation(latitude: successRoomData.ownerLocation.latitude, longitude: successRoomData.ownerLocation.longitude)
            
            let myMarker = GMSMarker(position: successRoomData.ownerLocation)
            
            myMarker.title = "You"
            
            myMarker.map = self.googleMapView
            
            myMarker.icon = GMSMarker.markerImage(with: UIColor.blue)
            
            self.googleMapView.animate(toLocation: successRoomData.ownerLocation)
            
            let hisMarker = GMSMarker(position: successRoomData.attenderLocation)
            
            hisMarker.title = "Eat Friend"
            
            hisMarker.map = self.googleMapView
            
            hisMarker.icon = GMSMarker.markerImage(with: UIColor.green)
            
        } else {
            
            self.myLocation = CLLocation(latitude: successRoomData.attenderLocation.latitude, longitude: successRoomData.attenderLocation.longitude)
            
            let myMarker = GMSMarker(position: successRoomData.attenderLocation)
            
            myMarker.title = "You"
            
            myMarker.map = self.googleMapView
            
            myMarker.icon = GMSMarker.markerImage(with: UIColor.blue)
            
            self.googleMapView.animate(toLocation: successRoomData.attenderLocation)
            
            let hisMarker = GMSMarker(position: successRoomData.ownerLocation)
            
            hisMarker.title = "Eat Friend"
            
            hisMarker.map = self.googleMapView
            
            hisMarker.icon = GMSMarker.markerImage(with: UIColor.green)
        }
        
        
        
    }
    
    func manager(_ manager: FetchMatchSuccessRoomDataManager, didFail withError: String) {
        
        print(withError)
        
    }
    
}
