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
import SCLAlertView

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
        //下面這些判斷 主要是因為locationManager會一直丟location給我 但我不想一直呼叫我的FetchNearbyLocationManager
        //所以做了一些限制條件讓他只會在真正需要的時候call
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
   
                        self.fetchNearbyLocationManager.requestNearbyLocation(coordinate: CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude), radius: 300)
                    
                }
                
            } else {
                // 第一個進來的location設為 currentLocation
                self.lastLocation = myLocation
                
                // 座標更新後呼叫拿取附近的地點
                self.fetchNearbyLocationManager.requestNearbyLocation(coordinate: CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude), radius: self.filterDistance)
            }
            
            locationManager.stopUpdatingLocation()
            self.currentLocation = myLocation
        } else {
            locationManager.startUpdatingLocation()
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

        print(nearLocations.count)
        
        let myLocation = currentLocation
        
        fetchDistanceManager.fetchDistance(myLocation: myLocation, nearLocations: nearLocations)

        if nextPageToken != nil {
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

extension NearbyViewController: FetchPlaceIdDetailDelegate {
    
    func manager(_ manager: FetchPlaceIdDetailManager, searchBy placeId: String, didGet locationWithDetail: Location, senderTag: Int) {
        
        nearbyLocationDictionary["\(placeId)"] = locationWithDetail
        
        self.locations[senderTag] = locationWithDetail
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 15)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 10)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        alert.addButton("OK") {
            alert.dismiss(animated: true, completion: nil)
        }
        
        let subTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 216, height: 70))
        let x = (subTextView.frame.width - 180) / 2
        
        let textView = UITextView(frame: CGRect(x: x, y: 10, width: 180, height: 50))
        textView.text = "電話號碼為 \(self.locations[senderTag].formattedPhoneNumber)"
        textView.layer.borderColor = UIColor.blue.cgColor
        textView.layer.borderWidth = 1.5
        textView.layer.cornerRadius = 5
        subTextView.addSubview(textView)
        alert.customSubview = subTextView
        
        alert.showTitle("\(self.locations[senderTag].name)", subTitle: "", style: .success)
        
    }
    
    func manager(_ manager: FetchPlaceIdDetailManager, didFailWith error: Error) {
        
    }
}

extension NearbyViewController: FetchPlaceImageDelegate {
    
    func manager(_ manager: FetchPlaceImageManager, fetch imageView: UIImageView, imageOfIndexPathRow: Int) {
        
        print(imageOfIndexPathRow)
        DispatchQueue.main.async {
//            self.locations[imageOfIndexPathRow].photo = imageView
            self.mapTableView.reloadData()
        }
        
    }
    
    func manager(_ manager: FetchPlaceImageManager, didFailWith error: Error) {
        
    }
    
}

extension NearbyViewController: FetchDistanceDelegate {
    
    func manager(_ manager: FetchDistanceManager, didGet nearLocationsWithDistance: [Location]) {
        
        //每個地點delegate去獲取詳細資訊
        for location in nearLocationsWithDistance {
            
            if nearbyLocationDictionary["\(location.placeId)"] == nil {
                
                let coordinates = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                
                let marker = GMSMarker(position: coordinates)
                
                marker.title = location.name
                
                marker.map = self.googleMapView
                
                //self.googleMapView.animate(toLocation: coordinates)
                
                nearbyLocationDictionary["\(location.placeId)"] = location
                
                self.locations.append(location)
                fetchedLocations.append(location)
                
                loadFirstPhotoForPlace(placeID: location.placeId, indexPathRow: (self.locations.count - 1))
                
            } else {
                print("已經出現過", location.name)
            }
        }
        self.mapTableView.reloadData()
        
        if self.lastPageToken != "" && self.lastPageToken == self.nextPageToken {
            return
        }
      DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) { 
        self.lastPageToken = self.nextPageToken
        self.fetchNearbyLocationManager.fetchRequestHandler(urlString: "", nextPageToken: self.nextPageToken)
        }

        
    }
    
    func manager(_ manager: FetchDistanceManager, didFailWith error: Error) {
        
    }
    
}
