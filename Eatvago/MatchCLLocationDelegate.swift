//
//  MatchCLLocationDelegate.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/12.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import GoogleMaps

extension MatchSuccessViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let myLocation: CLLocation = locations.last!
        
        let camera = GMSCameraPosition.camera(withLatitude: myLocation.coordinate.latitude,
                                              longitude: myLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if googleMapView.isHidden {
            
            googleMapView.isHidden = false
            
            googleMapView.camera = camera
            
        } else {
            
            googleMapView.animate(to: camera)
            
        }
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            
            case .restricted:
            
                print("Location access was restricted.")
            
            case .denied:
            
                print("User denied access to location.")
                
                googleMapView.isHidden = false
            
            case .notDetermined:
            
                print("Location status not determined.")
            
            case .authorizedAlways:
            
                fallthrough
            
            case .authorizedWhenInUse:
            
                print("Location status is OK.")
            
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        locationManager.stopUpdatingLocation()
        
        print("Error: \(error)")
    }

}
