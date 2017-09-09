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
import NVActivityIndicatorView
import FirebaseDatabase
import Firebase
import SCLAlertView
import FSPagerView
import ExpandingMenu

//swiftlint:disable type_body_length
class NearbyViewController: UIViewController, FSPagerViewDataSource, FSPagerViewDelegate, NVActivityIndicatorViewable, UITabBarControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var nearByInfoBackgroundView: UIView!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBOutlet weak var storeDurationTimeLabel: UILabel!
    
    @IBOutlet weak var storeDistanceLabel: UILabel!
    
    @IBOutlet weak var storeNavigationButton: UIButton!

    @IBOutlet weak var addToListButton: UIButton!
    
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var loadingNVAView: NVActivityIndicatorView!
    
    @IBOutlet weak var userInfoTextBackgroundView: UIView!

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var functionBarView: UIView!
    
    @IBOutlet weak var bottomFunctionBarView: UIView!
    
    @IBOutlet weak var settingLabel: UILabel!
    
    @IBOutlet weak var settingTitleLabel: UILabel!
    
    @IBOutlet weak var baseBackgroundView: UIView!
    
    @IBOutlet weak var nearbyInfoBackgroundImageView: UIImageView!
    
    //set up pager view
    
    @IBOutlet weak var storeImagePagerView: FSPagerView! {
        
        didSet {
            
            self.storeImagePagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.typeIndex = 1
            
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
            self.storeImagePagerView.transformer = FSPagerViewTransformer(type:type)
            switch type {
            case .crossFading, .zoomOut, .depth:
                self.storeImagePagerView.itemSize = .zero // 'Zero' means fill the size of parent
            case .linear, .overlap:
                let transform = CGAffineTransform(scaleX: 0.6, y: 0.75)
                self.storeImagePagerView.itemSize = self.storeImagePagerView.frame.size.applying(transform)
            case .ferrisWheel, .invertedFerrisWheel:
                self.storeImagePagerView.itemSize = CGSize(width: 180, height: 140)
            case .coverFlow:
                self.storeImagePagerView.itemSize = CGSize(width: 220, height: 170)
            case .cubic:
                let transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.storeImagePagerView.itemSize = self.storeImagePagerView.frame.size.applying(transform)
            }
        }
    }
    
    // setup pagerViewControl
    
    @IBOutlet weak var firstLeftTwoPagerViewControlView: UIView!
    
    @IBOutlet weak var firstLeftOnePagerViewControlView: UIView!
    
    @IBOutlet weak var firstPagerViewControlView: UIView!

    @IBOutlet weak var secondPagerViewControlView: UIView!
    
    @IBOutlet weak var thirdPagerViewControlView: UIView!
    
    @IBOutlet weak var thirdRightOnePagerViewControlView: UIView!
    
    @IBOutlet weak var thirdRightTwoPagerViewControlView: UIView!

    var window: UIWindow?
    
    // 與TabBarcontroller分享的Model
    var fetchedLocations = [Location]()
    
    //Declare the location manager, current location, map view, places client, and default zoom level at the class level
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var googleMapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 18.0
    var filterDistance = 500.0
    var keywordText = ""
    //附近的地點 base on mylocation
    var locations: [Location] = []
    
    //建立呼叫fetchNearbyLocation使用的location 用途：避免重複互叫fetchNearbyLocationManager
    var lastLocation: CLLocation?
    
    //建立location的字典 座標是key 值是location struct  目的: 改善地點間交集的狀況
    var nearbyLocationDictionary: [String : Location ] = [:]
    
    let uploadOrDownLoadUserPhotoManager = UploadOrDownLoadUserPhotoManager()
    let fetchNearbyLocationManager = FetchNearbyLocationManager()
    let fetchPlaceIdDetailManager = FetchPlaceIdDetailManager()
    let fetchLocationImageManager = FetchLocationImageManager()
    let fetchDistanceManager = FetchDistanceManager()
    var nextPageToken = ""
    var lastPageToken = ""
    var fetchPageCount = 0
    
    //給予假資料 讓下面不用解optional
    var choosedLocation = Location(latitude: 0, longitude: 0, name: "", id: "", placeId: "", types: [], priceLevel: nil, rating: nil, photoReference: "")
    
    //用來add資訊
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
    weak var tabBarC: MainTabBarController?
    
    //pickerViewData
    var distancePickOption = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
    var distanceTextField = UITextField()
    
    //全螢幕讀取 下載圖片或上傳圖片
    let activityData = ActivityData()
    
    //存取user圖片
    var userPhotoImageView = UIImageView()
    
    //userPhoto alert
    var userProfileAlertView = SCLAlertView()
    
    // userImageView In alertview
    var userImageViewInAlertView = UIImageView()
    
    //pagerview用參數控制紅點
    var pagerViewLastIndex = 0
    var pagerViewControlRedPoint = 2
    var tempPagerControlBigPointView = UIView()
    var tempPagerControlLittlePointView = UIView()
    
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
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        tabBarC = self.tabBarController as? MainTabBarController
        tabBarC?.fetchedLocations = self.locations
        tabBarC?.delegate = self
        tabBarC?.nearbyViewController = self

        // 配置 locationManager
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        
        // set up pagerview delegate

        self.storeImagePagerView.delegate = self
        self.storeImagePagerView.dataSource = self
        self.storeImagePagerView.isInfinite = true
        
        fetchNearbyLocationManager.delegate = self
        fetchPlaceIdDetailManager.delegate = self
        fetchDistanceManager.delegate = self
        fetchLocationImageManager.delegate = self
        uploadOrDownLoadUserPhotoManager.delegate = self

        ref = Database.database().reference()

        stepUpUserPhotoGesture()
        
        uploadOrDownLoadUserPhotoManager.downLoadUserPhoto()
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        //button function
        addToListButton.addTarget(self, action: #selector(addToList), for: .touchUpInside)
        
        //layout
        setupLayout()
        
        addMenuButton()
        
        //keyboard 收下去
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        self.view.addGestureRecognizer(tap)
        
        Analytics.logEvent("Nearby_viewDidLoad", parameters: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        tabBarC?.fetchedLocations = self.locations
        
        tabBarC?.delegate = self
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        self.locationManager.stopUpdatingLocation()
        
        tabBarC?.fetchedLocations = self.locations
        
        tabBarC?.userPhoto = self.userPhotoImageView
        
    }
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        return locations.count
        
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        callPageControlBaseOnIndex(index)
  
        let location = locations[index]
        
        if location.photo == nil {

            self.loadingNVAView.startAnimating()
            
            cell.imageView?.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
                
                self.loadingNVAView.stopAnimating()
                
                self.loadingNVAView.isHidden = true
                
                if cell.imageView?.image == nil {
                    
                    cell.imageView?.isHidden = false
                    
                    cell.imageView?.image = UIImage(named: "notFound")
                    
                    cell.imageView?.contentMode = .center
                    
                }
            })

        } else {
            
            self.loadingNVAView.stopAnimating()
            
            self.loadingNVAView.isHidden = true
            
            cell.imageView?.isHidden = false
            
            guard let storeImage = location.photo else {
                
                return FSPagerViewCell()
                
            }
            
            DispatchQueue.main.async {
                
                cell.imageView?.image = storeImage
                
                cell.imageView?.contentMode = .scaleAspectFill
                
            }

        }
        
        storeDistanceLabel.text = location.distanceText
        
        storeDurationTimeLabel.text = location.durationText + "\n (Walking)"
        
        storeNameLabel.text = location.name
        
        choosedLocation = location
        
        addToListButton.tintColor = UIColor(
            red: 255.0/255.0,
            green: 235.0/255.0,
            blue: 245.0/255.0,
            alpha: 1.0
        )
        
        for locationInList in (tabBarC?.addLocations) ?? [] {
            
            if locationInList.name == choosedLocation.name {
                
                addToListButton.tintColor = UIColor.red
                
            } else { }
           
        }
        
        return cell
    }
    
    func showStoreDetail(_ sender: UIButton) {
        
        self.fetchPlaceIdDetailManager.requestPlaceIdDetail(
            locationsWithoutDetail:
            self.locations[sender.tag],
            senderTag: sender.tag
        )
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return distancePickOption.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(distancePickOption[row])"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        distanceTextField.text = "\(distancePickOption[row])"
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}
