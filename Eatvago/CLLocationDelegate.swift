//
//  NearbyLocationDelegateFunction.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/7/27.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//
import UIKit
import GoogleMaps


extension NearbyViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let myLocation: CLLocation = locations.last!
        print("Location: \(myLocation)")
        
        let camera = GMSCameraPosition.camera(withLatitude: myLocation.coordinate.latitude,
                                              longitude: myLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if googleMapView.isHidden {
            googleMapView.isHidden = false
            googleMapView.camera = camera
        } else {
            googleMapView.animate(to: camera)
        }
        
        callFetchNearbyLocations(myLocation: myLocation)

    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            
            print("Location access was restricted.")
            
        case .denied:
            
            print("User denied access to location.")
            // Display the map using the default location.
            googleMapView.isHidden = false
            
        case .notDetermined:
            
            print("Location status not determined.")
            
        case .authorizedAlways:
            
            fallthrough
            
        case .authorizedWhenInUse:
            
            print("Location status is OK.")
            
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        locationManager.stopUpdatingLocation()
        
        print("Error: \(error)")
    }
    
    func callFetchNearbyLocations(myLocation: CLLocation) {
        
        //做了一些限制條件讓他只會在真正需要的時候call
        if myLocation != CLLocation() {
            //與前次地點相同則不摳
            if self.lastLocation != nil {
                
                guard let lastLocation = self.lastLocation else {
                    
                    print("lastLocation or current location guard let fail")
                    
                    return
                }
                //1公尺約0.00000900900901度
                // 如果超過一定範圍則重置字典
                if Double((lastLocation.coordinate.latitude)) + 0.00001 < Double((myLocation.coordinate.latitude))
                    || Double((lastLocation.coordinate.latitude)) - 0.00001 > Double((myLocation.coordinate.latitude))
                    || Double((lastLocation.coordinate.longitude)) + 0.00001 < Double((myLocation.coordinate.longitude))
                    || Double((lastLocation.coordinate.longitude)) + 0.00001 < Double((myLocation.coordinate.longitude)) {
                    
                    self.nearbyLocationDictionary = [:]
                    
                    self.locations = []
                    
                    self.lastLocation = myLocation
                    
                    self.fetchNearbyLocationManager.requestNearbyLocation(coordinate: CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude), radius: self.filterDistance, keywordText: self.keywordText)
                    
                }
                
            } else {
                // 第一個進來的location設為 currentLocation
                self.lastLocation = myLocation
                // 座標更新後呼叫拿取附近的地點
                self.fetchNearbyLocationManager.requestNearbyLocation(coordinate: CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude), radius: self.filterDistance, keywordText: self.keywordText)
            }
            
            locationManager.stopUpdatingLocation()
            
            self.currentLocation = myLocation
            
        } else {
            
            locationManager.startUpdatingLocation()
        }

    }
    
}
