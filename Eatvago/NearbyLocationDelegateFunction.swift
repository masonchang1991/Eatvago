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
        if self.googleMapView.myLocation != nil {
            
            //與前次地點相同則不摳
            if self.lastLocation == self.googleMapView.myLocation {

                //1公尺約0.00000900900901度
                // 如果超過一定範圍則重置字典
                
            } else {
                // 第一個進來的location設為 currentLocation
                self.lastLocation = self.googleMapView.myLocation
                // 將原本locations（會show在tableview上面的）清除
                self.locations = []
                // 座標更新後呼叫拿取附近的地點
                if let myLocation = self.googleMapView.myLocation {
                    self.fetchNearbyLocationManager.requestNearbyLocation(coordinate: CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude), radius: 300)
                }
                
            }
            
        } else {
//            locationManager.stopUpdatingLocation()
//            self.locations = []
//            locationManager.startUpdatingLocation()
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
    
    func manager(_ manager: FetchNearbyLocationManager, didGet nearLocations: [Location], nextPageToken: String?) {
        //單純解除optional 為了傳遞給fetchplacedetailManager
        guard let mylocation = self.googleMapView.myLocation else {
            return
        }
        print(nearLocations.count)
        for location in nearLocations {
            //每個地點delegate去獲取詳細資訊
            fetchPlaceIdDetailManager.requestPlaceIdDetail(placeId: location.placeId, locationWithoutDetail: location, myLocation: mylocation)
        }
//        if nextPageToken != nil {
//            guard let pageToken = nextPageToken else {
//                return
//            }
//            let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=\(pageToken)&key=\(googleMapAPIKey)"
//            DispatchQueue.global().async {
//                self.fetchNearbyLocationManager.fetchRequestHandler(urlString: urlString)
//            }
//            
//        } else {
//            print("there is no other page")
//        }
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
            print(self.locations.count)
            self.mapTableView.reloadData()

//            fetchPlaceImageManager.fetchImage(locationPhotoReference: locationWithDetail.photoReference, imageOfIndexPathRow: (self.locations.count - 1))
            
            
            
        } else {
            print("已經出現過", locationWithDetail.name)
        }
    }
    
    func manager(_ manager: FetchPlaceIdDetailManager, didFailWith error: Error) {
        
    }
}


extension NearbyViewController: FetchPlaceImageDelegate {
    
    func manager(_ manager: FetchPlaceImageManager, fetch image: UIImageView, imageOfIndexPathRow: Int) {
        
        print(imageOfIndexPathRow)
        
        
        self.locations[imageOfIndexPathRow].photo = image
        let indexPath = NSIndexPath(row: imageOfIndexPathRow, section: 0)
        self.mapTableView.reloadRows(at: [indexPath as IndexPath], with: .middle)

        //            print("index path", imageOfIndexPathRow, "!!!!!!!!!!!!!!!!!!!!")
        
        
        
        
        
        
        
    }
    
    func manager(_ manager: FetchPlaceImageManager, didFailWith error: Error) {
        
        
    }
    
    
    
    
    
}
