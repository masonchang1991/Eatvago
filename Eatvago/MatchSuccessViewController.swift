//
//  MatchSuccessViewController.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/11.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces


class MatchSuccessViewController: UIViewController, FetchMatchSuccessRoomDataDelegate {
    
    @IBOutlet weak var mapView: UIView!
    
    
    var matchRoomRef = DatabaseReference()
    
    var matchSuccessRoomRef = DatabaseReference()
    
    var myName = ""
    
    var oppositePeopleName = ""
    
    var myPhotoImageView = UIImageView()
    
    var oppositePeopleImageView: UIImageView?
    
    var fetchRoomDataManager = FetchMatchSuccessRoomDataManager()
    
    //Declare the location manager, current location, map view, places client, and default zoom level at the class level
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var googleMapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 18.0
    var filterDistance = 100.0
    var keywordText = ""
    //附近的地點 base on mylocation
    var locations: [Location] = []
    
    //建立呼叫fetchNearbyLocation使用的location 用途：避免重複互叫fetchNearbyLocationManager
    var lastLocation: CLLocation?
    
    //建立location的字典 座標是key 值是location struct  目的: 改善地點間交集的狀況
    var nearbyLocationDictionary: [String : Location ] = [:]
    
    let fetchNearbyLocationManager = FetchNearbyLocationManager()
    let fetchPlaceIdDetailManager = FetchPlaceIdDetailManager()
    let fetchLocationImageManager = FetchLocationImageManager()
    let fetchDistanceManager = FetchDistanceManager()
    var nextPageToken = ""
    var lastPageToken = ""
    var fetchPageCount = 0
    
    override func loadView() {
        super.loadView()
        
        //設置初始點
        let camera = GMSCameraPosition.camera(withLatitude: 25.042476,
                                              longitude: 121.564882,
                                              zoom: 20)
        
        googleMapView = GMSMapView.map(withFrame: mapView.bounds,
                                       camera: camera)
        
        googleMapView.settings.myLocationButton = true
        
        googleMapView.autoresizingMask = [.flexibleWidth,
                                          .flexibleHeight]
        googleMapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        mapView.addSubview(googleMapView)
        
        googleMapView.isHidden = true
        
        mapView.isHidden = true
        
    }

    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ifAnyoneDeclineObserver()
        
        
        self.fetchRoomDataManager.delegate = self
        
        self.fetchRoomDataManager.fetchRoomData(matchSuccessRoomRef: matchSuccessRoomRef)
        
        
        // 配置 locationManager
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        
//        fetchNearbyLocationManager.delegate = self
//        fetchPlaceIdDetailManager.delegate = self
//        fetchDistanceManager.delegate = self
//        fetchLocationImageManager.delegate = self
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    func ifAnyoneDeclineObserver() {
        
        matchRoomRef.child("isClosed").observe(.value, with: { (snapshot) in
            
            guard let isClosed = snapshot.value as? Bool else {
                return
            }
            
            if isClosed == true {
                
                //跳出alert
                // 建立一個提示框
                let alertController = UIAlertController(
                    title: "Sorry",
                    message: "You have been declined",
                    preferredStyle: .alert)
                
                // 建立[OK]按鈕
                let okAction = UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.default) { (_: UIAlertAction!) -> Void in
                        
                        self.performSegue(withIdentifier: "goBackToMain", sender: nil)
                        
                }
                alertController.addAction(okAction)
                self.present(
                    alertController,
                    animated: true,
                    completion: nil)
                
            }
            
        })

        
        
    }

    func manager(_ manager: FetchMatchSuccessRoomDataManager, didGet successRoomData: MatchSuccessRoom) {
        
        print(successRoomData)
        
        
    }
    
    func manager(_ manager: FetchMatchSuccessRoomDataManager, didFail withError: String) {
        
        print(withError)
        
    }


}
