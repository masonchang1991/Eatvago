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
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if googleMapView.isHidden {
            googleMapView.isHidden = false
            googleMapView.camera = camera
        } else {
            googleMapView.animate(to: camera)
        }
        //下面這些判斷 主要是因為locationManager會一直丟location給我 但我不想一直呼叫我的FetchNearbyLocationManager
        //所以做了一些限制條件讓他只會在真正需要的時候call
        if self.googleMapView.myLocation != nil && (locationOfFetchNearby != self.googleMapView.myLocation || locationOfFetchNearby == nil) {
            
            if self.locationOfFetchNearby != nil {
                guard let location = self.locationOfFetchNearby,
                    let myLocation = self.googleMapView.myLocation else {
                        return
                }
                //1公尺約0.00000900900901度
                // 如果超過一定範圍則重置字典
                if Double((location.coordinate.latitude)) + 0.00001 < Double((myLocation.coordinate.latitude))
                    || Double((location.coordinate.latitude)) - 0.00001 > Double((myLocation.coordinate.latitude))
                    || Double((location.coordinate.longitude)) + 0.00001 < Double((myLocation.coordinate.longitude))
                    || Double((location.coordinate.longitude)) + 0.00001 < Double((myLocation.coordinate.longitude)) {

                    self.nearbyLocationDictionary = [:]
                    
                    let fetchNearbyLocationManager = FetchNearbyLocationManager()
                    fetchNearbyLocationManager.delegate = self
                    // 第一個進來的location設為 currentLocation
                    self.locationOfFetchNearby = self.googleMapView.myLocation
                    // 將原本locations（會show在tableview上面的）清除
                    self.locations = []
                    // 座標更新後呼叫拿取附近的地點
                    fetchNearbyLocationManager.requestNearbyLocation(coordinate: CLLocationCoordinate2DMake((self.googleMapView.myLocation?.coordinate.latitude)!, (self.googleMapView.myLocation?.coordinate.longitude)!), radius: 500)
                    
                } else {
                    print("不用更新")
                }
                
            } else {
                let fetchNearbyLocationManager = FetchNearbyLocationManager()
                fetchNearbyLocationManager.delegate = self
                // 第一個進來的location設為 currentLocation
                self.locationOfFetchNearby = self.googleMapView.myLocation
                // 將原本locations（會show在tableview上面的）清除
                self.locations = []
                // 座標更新後呼叫拿取附近的地點
                fetchNearbyLocationManager.requestNearbyLocation(coordinate: CLLocationCoordinate2DMake((self.googleMapView.myLocation?.coordinate.latitude)!, (self.googleMapView.myLocation?.coordinate.longitude)!), radius: 500)
            }
            
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
        
        print(locations.count)
        for location in locations {
            //每個地點delegate去獲取詳細資訊
            let fetchPlaceIdDetailManager = FetchPlaceIdDetailManager()
            fetchPlaceIdDetailManager.delegate = self
            fetchPlaceIdDetailManager.requestPlaceIdDetail(placeId: location.placeId, locationWithoutDetail: location)
        }
        if nextPageToken != nil {
            guard let pageToken = nextPageToken else {
                return
            }
            let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=\(pageToken)&key=\(googleMapAPIKey)"
            let fetchNearbyLocationManager = FetchNearbyLocationManager()
            fetchNearbyLocationManager.delegate = self
            fetchNearbyLocationManager.fetchRequestHandler(urlString: urlString)
        } else {
            print("there is no other page")
        }
    }
    func manager(_ manager: FetchNearbyLocationManager, didFailWith error: Error) {
        
        print(error)
        
    }
}

extension NearbyViewController: FetchPlaceIdDetailDelegate {
    
    func manager(_ manager: FetchPlaceIdDetailManager, searchBy placeId: String, didGet locationWithDetail: Location) {
        
        if nearbyLocationDictionary["\(placeId)"] == nil {
            let coordinates = CLLocationCoordinate2DMake(locationWithDetail.latitude, locationWithDetail.longitude)
            let marker = GMSMarker(position: coordinates)
            marker.title = locationWithDetail.name
            marker.map = self.googleMapView
            self.googleMapView.animate(toLocation: coordinates)
            nearbyLocationDictionary["\(placeId)"] = locationWithDetail
            self.locations.append(locationWithDetail)
            self.mapTableView.reloadData()
            
        } else {
            print("已經出現過")
        }
    }
    
    func manager(_ manager: FetchPlaceIdDetailManager, didFailWith error: Error) {
        
    }
}
