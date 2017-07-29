//
//  NearbyLocationDelegateFunction.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/7/27.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//
import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

extension NearbyViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        //print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if googleMapView.isHidden {
            googleMapView.isHidden = false
            googleMapView.camera = camera
        } else {
            googleMapView.animate(to: camera)
        }
        
        let fetchNearbyLocationManager = FetchNearbyLocationManager()
        fetchNearbyLocationManager.delegate = self
        if self.googleMapView.myLocation != nil && locationOfFetchNearby != self.googleMapView.myLocation {
            // 第一個進來的location設為 currentLocation
            self.locationOfFetchNearby = self.googleMapView.myLocation
            self.locations = []
            // 座標更新後呼叫拿取附近的地點
            print(self.locationOfFetchNearby)
            fetchNearbyLocationManager.requestNearbyLocation(coordinate: CLLocationCoordinate2DMake((self.googleMapView.myLocation?.coordinate.latitude)!, (self.googleMapView.myLocation?.coordinate.longitude)!), radius: 100)
        }
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
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}


extension NearbyViewController: FetchLocationDelegate {

    func manager(_ manager: FetchNearbyLocationManager, didGet locations: [Location], nextPageToken: String?) {
        
        for location in locations {
  
            let coordinates = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            
            if nearbyLocationDictionary["\(coordinates)"] == nil {
                
                let marker = GMSMarker(position: coordinates)
                marker.title = location.name
                marker.map = self.googleMapView
                self.googleMapView.animate(toLocation: coordinates)
                self.mapTableView.reloadData()
                self.locations.append(location)
                
                nearbyLocationDictionary["\(coordinates)"] = location
            } else {
                print("已經出現過")
            }
            
        }
        
        if nextPageToken != nil {
            guard let pageToken = nextPageToken else {
                return
            }
            let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=\(pageToken)&key=\(googleMapAPIKey)"
           // fetchNearbyLocationManager.fetchRequestHandler(urlString: urlString)
        } else {
            print("there is no other page")
        }

        
        
    }
    func manager(_ manager: FetchNearbyLocationManager, didFailWith error: Error) {
        
        print(error)
        
    }
    
    

}
