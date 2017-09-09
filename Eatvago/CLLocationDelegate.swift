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
        
        self.currentLocation = myLocation
        
        print(self.currentLocation.coordinate.longitude)

        let camera = GMSCameraPosition.camera(withLatitude: myLocation.coordinate.latitude,
                                              longitude: myLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if googleMapView.isHidden {
            
            googleMapView.isHidden = false
            
            googleMapView.camera = camera
            
        } else {
            
            googleMapView.animate(to: camera)
            
        }

        guard let lastLocation = self.lastLocation else {
            
            callIfFetchNearbyLocations(myLocation: myLocation)
            
            print("第一次定位")
            
            return
        }
        
        if Double(myLocation.distance(from: lastLocation)) < 10 {
            
            return
            
        }

        callIfFetchNearbyLocations(myLocation: myLocation)

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
    
    func callIfFetchNearbyLocations(myLocation: CLLocation) {
        
        //做了一些限制條件讓他只會在真正需要的時候call
        if myLocation != CLLocation() {
            //與前次地點相同則不摳
            if self.lastLocation != nil {
                
                self.nearbyLocationDictionary = [:]
                
                self.locations = []
                
                self.googleMapView.clear()
                
            }

            self.lastLocation = myLocation
            
            let myLocationCoordinate = CLLocationCoordinate2DMake(myLocation.coordinate.latitude,
                                                                  myLocation.coordinate.longitude)
            
            self.fetchNearbyLocationManager.requestNearbyLocation(coordinate: myLocationCoordinate,
                                                                  radius: self.filterDistance,
                                                                  keywordText: self.keywordText)

        }

    }
    
}
