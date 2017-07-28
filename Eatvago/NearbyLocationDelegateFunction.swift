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
        
        listLikelyPlaces()
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
    
    
    // Populate the array with the list of likely places.
    func listLikelyPlaces() {
        // Clean up from previous sessions.
        likelyPlaces.removeAll()
        
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                var compareLikelihood = 0.0
                
                for likelihood in likelihoodList.likelihoods {
                    
                    let probability = likelihood.likelihood
                    let place = likelihood.place
                    
                    // 透過回傳的可能性去找出最有可能的place
                    if probability > compareLikelihood {
                        compareLikelihood = probability
                        self.mostLikelyPlace = place
                    }
                    self.likelyPlaces.append(place)
                    self.mapTableView.reloadData()
                }
                self.showAroundPlacePicker()
            }

            
        })
    }

    
    func showAroundPlacePicker() {
        
        guard let position = mostLikelyPlace else {
            print("mostLikelyPlace == nil")
            return
        }
        
        let center = CLLocationCoordinate2DMake(position.coordinate.latitude, position.coordinate.longitude)
        let northEast = CLLocationCoordinate2DMake(center.latitude + 0.001, center.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center.latitude - 0.001, center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePickerViewController(config: config)
        
        // 2
        placePicker.delegate = self
        self.addChildViewController(placePicker)
        self.mapView.addSubview(placePicker.view)
    }
    
    
    

    
    
}


extension NearbyViewController: GMSPlacePickerViewControllerDelegate {
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        print(place)
        self.aroundPlace.append(place)
        let coordinates = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
        let marker = GMSMarker(position: coordinates)
        marker.title = place.name
        marker.map = self.googleMapView
        self.googleMapView.animate(toLocation: coordinates)
        self.mapTableView.reloadData()
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        print("Error occurred: \(error.localizedDescription)")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        NSLog("The place picker was canceled by the user")
        
        // Dismiss the place picker.
        viewController.dismiss(animated: true, completion: nil)
    }


}
