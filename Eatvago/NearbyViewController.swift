//
//  NearbyViewController.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/7/26.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
class NearbyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var mapTableView: UITableView!
    var window: UIWindow?
    //Declare the location manager, current location, map view, places client, and default zoom level at the class level
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var googleMapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0

    // 建立搜尋地點的manager
    var fetchNearbyLocationManager = FetchNearbyLocationManager()

    //附近的地點 base on mylocation
    var locations: [Location] = []
    
    //建立呼叫fetchNearbyLocation使用的location 用途：避免重複互叫fetchNearbyLocationManager
    var locationOfFetchNearby: CLLocation? = nil
    
    //建立location的字典 座標是key 值是location struct  目的: 改善地點間交集的狀況
    var nearbyLocationDictionary: [String : Location ] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //設置初始點
        let camera = GMSCameraPosition.camera(withLatitude: 25.042476, longitude: 121.564882, zoom: 20)
        googleMapView = GMSMapView.map(withFrame: mapView.bounds, camera: camera)
        googleMapView.settings.myLocationButton = true
        googleMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        googleMapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        mapView.addSubview(googleMapView)
        googleMapView.isHidden = true
        mapView.isHidden = true

        mapTableView.delegate = self
        mapTableView.dataSource = self

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        self.locationOfFetchNearby = nil
        
        // 配置 locationManager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mapTableViewCell", for: indexPath) as? NearbyMapTableViewCell else {
            return UITableViewCell()
        }
        let collectionItem = locations[indexPath.row]
        
        cell.mapTextLabel.text = collectionItem.name
    
        return cell
    }
    
    // Show only the first five items in the table (scrolling is disabled in IB).
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.mapTableView.frame.size.height/5
    }
    
    // Make table rows display at proper height if there are less than 5 items.
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == tableView.numberOfSections - 1) {
            return 1
        }
        return 0
    }
    
    @IBAction func changTableViewAndMap(_ sender: UIButton) {
        if mapTableView.isHidden == true {
            mapTableView.isHidden = false
            mapView.isHidden = true
            sender.setTitle("Map", for: .normal)
        } else {
            mapView.isHidden = false
            mapTableView.isHidden = true
            sender.setTitle("Table", for: .normal)
        }
        
    }

    @IBAction func logout(_ sender: UIButton) {
        // 消去 UserDefaults內使用者的帳號資訊
        UserDefaults.standard.setValue(nil, forKey: "UserLoginEmail")
        UserDefaults.standard.setValue(nil, forKey: "UserLoginPassword")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
        self.window?.rootViewController = nextVC
    }

}
