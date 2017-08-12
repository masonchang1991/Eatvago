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
import FSPagerView

class MatchSuccessViewController: UIViewController, FSPagerViewDataSource, FSPagerViewDelegate {
    
    @IBOutlet weak var mapView: UIView!
    
    
    @IBOutlet weak var mapAndListChangeButton: UIButton!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBOutlet weak var listPagerView: FSPagerView! {
        
        didSet {
            
            self.listPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.typeIndex = 3
            
        }
    }
    
    fileprivate let transformerTypes: [FSPagerViewTransformerType] = [.crossFading,
                                                                      .zoomOut,
                                                                      .depth,
                                                                      .linear,
                                                                      .overlap,
                                                                      .ferrisWheel,
                                                                      .invertedFerrisWheel,
                                                                      .coverFlow,
                                                                      .cubic]
    fileprivate var typeIndex = 0 {
        didSet {
            let type = self.transformerTypes[typeIndex]
            self.listPagerView.transformer = FSPagerViewTransformer(type:type)
            switch type {
            case .crossFading, .zoomOut, .depth:
                self.listPagerView.itemSize = .zero // 'Zero' means fill the size of parent
            case .linear, .overlap:
                let transform = CGAffineTransform(scaleX: 0.6, y: 0.75)
                self.listPagerView.itemSize = self.listPagerView.frame.size.applying(transform)
            case .ferrisWheel, .invertedFerrisWheel:
                self.listPagerView.itemSize = CGSize(width: 180, height: 140)
            case .coverFlow:
                self.listPagerView.itemSize = CGSize(width: 220, height: 170)
            case .cubic:
                let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.listPagerView.itemSize = self.listPagerView.frame.size.applying(transform)
            }
        }
    }

    
    
    var matchRoomRef = DatabaseReference()
    
    var matchSuccessRoomRef = DatabaseReference()
    
    var myName = ""
    
    var oppositePeopleName = ""
    
    var isRoomOwner = false
    
    var type = ""
    
    var listRoomId = ""
    
    var myPhotoImageView = UIImageView()
    
    var oppositePeopleImageView: UIImageView?
    
    var fetchRoomDataManager = FetchMatchSuccessRoomDataManager()
    
    var choosedLocation = ChoosedLocation(storeName: "", locationLat: "", locationLon: "")
    
    var choosedLocations: [String: ChoosedLocation] = [:]
    
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
    var myLocation = CLLocation()
    
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
        
        fetchNearbyLocationManager.delegate = self
        fetchPlaceIdDetailManager.delegate = self
        fetchDistanceManager.delegate = self
        fetchLocationImageManager.delegate = self
        
        
        //配置pagerView
        
        self.listPagerView.delegate = self
        self.listPagerView.dataSource = self
        
        
        
        
    }
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return locations.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        let location = locations[index]
        
        print(index)
        
        
        if location.photo == nil {
            
            cell.imageView?.image = UIImage(named: "noImage")
            cell.imageView?.contentMode = .scaleAspectFit
            
            
        } else {
            
            guard let storeImage = location.photo else {
                return FSPagerViewCell()
            }
            
            cell.imageView?.image = storeImage
            cell.imageView?.contentMode = .scaleAspectFit
            
        }
        
        durationLabel.text = location.durationText
        
        distanceLabel.text = location.distanceText
        
        storeNameLabel.text = location.name
        
        choosedLocation = ChoosedLocation(storeName: location.name, locationLat: String(location.latitude), locationLon: String(location.longitude))
        //將location存入
        
        return cell
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

    
    @IBAction func addToList(_ sender: Any) {
        
        //檢查是否有value
        
        var ref = Database.database().reference()
        
        
        self.matchSuccessRoomRef = ref.child("Connection").child("-KrKo9mJ9yBW7MYjRxP8")
        
        self.matchSuccessRoomRef.child("list").observe(.value, with: { (snapshot) in
            
            self.choosedLocations = [:]
            
            guard let locations = snapshot.value as? [[String: [String: String]]] else {
                
                let location = ["location": self.choosedLocation]
                self.matchSuccessRoomRef.child("list").childByAutoId().updateChildValues(location)
                return
                
            }
            
            for location in locations {

                for (_, locationValue) in location {
                    
                    let storeName = locationValue["storeName"]
                    
                    let locationLat = locationValue["locationLat"]
                    
                    let locationLon = locationValue["locationLon"]
                    
                    self.choosedLocations[storeName ?? ""] = ChoosedLocation(storeName: storeName ?? "",
                                                                       locationLat: locationLat ?? "",
                                                                       locationLon: locationLon ?? "")
                    

                }
                
            }
            
            if self.choosedLocations[self.choosedLocation.storeName] == nil {
                
                let location = ["location": self.choosedLocation]
                
                self.matchSuccessRoomRef.child("list").childByAutoId().updateChildValues(location)
                
            }

        })
    }
    
    
    
    
    
    
    
//    func segmentedHandler() {
//        
//        //如果selectedSegment有變更則用動畫的方式調整name 跟 phone的ishidden狀態
//        if setSegmentedControl.selectedSegmentIndex == 0 {
//            
//            reloadRandomBallView()
//            openSetRandomButton.isHidden = false
//            searchView.isHidden = true
//            addListCollectionView.isHidden = true
//            setRandomView.isHidden = true
//            
//        } else {
//            
//            reloadRandomBallView()
//            openSetRandomButton.isHidden = true
//            searchView.isHidden = false
//            addListCollectionView.isHidden = false
//            setRandomView.isHidden = false
//            
//        }
//        
//    }

    
    
    
    
    
    @IBAction func mapAndListChange(_ sender: Any) {
        
        if mapView.isHidden == true {
            
            mapView.isHidden = false
            listPagerView.isHidden = true
            
            
        } else {
            
            mapView.isHidden = true
            listPagerView.isHidden = false
            
            
        }
        
        
        
    }
//    
//    @IBAction func setSegmentControl(_ sender: UISegmentedControl) {
//        
//        segmentedHandler()
//    }


}
