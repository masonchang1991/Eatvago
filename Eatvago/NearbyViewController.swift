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

class NearbyViewController: UIViewController, FSPagerViewDataSource, FSPagerViewDelegate, NVActivityIndicatorViewable, UITabBarControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var userPhotoImageView: UIImageView!

    @IBOutlet weak var userInfoTextView: UITextView!
    
    @IBOutlet weak var userInfoBackgroundView: UIView!
    
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
    
    //filter text
    var distanceString = ""
    var keyword = ""
    
    //全螢幕讀取 下載圖片或上傳圖片
    let activityData = ActivityData()
    
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
        
        tabBarC = self.tabBarController as? MainTabBarController
        tabBarC?.fetchedLocations = self.locations
        tabBarC?.delegate = self
        tabBarC?.nearbyViewController = self

        // 配置 locationManager
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        
        // set up pagerview delegate

        self.storeImagePagerView.delegate = self
        self.storeImagePagerView.dataSource = self
        
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
        
        //keyboard 收下去
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        //加入menu button
        
        let menuButtonSize: CGSize = CGSize(width: 40, height: 40)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), centerImage: UIImage(named: "menu")!, centerHighlightedImage: UIImage(named: "menu")!)
        menuButton.center = CGPoint(x: 20.0, y: 20.0)
        view.addSubview(menuButton)
        
        
        let mapButton = ExpandingMenuItem(size: menuButtonSize, image: UIImage(named: "Map")!, highlightedImage: UIImage(named: "Map")!, backgroundImage: nil, backgroundHighlightedImage: nil) {
            
            self.changTableViewAndMap()
            
        }
        
        let setupButton = ExpandingMenuItem(size: menuButtonSize, image: UIImage(named: "Setup")!, highlightedImage: UIImage(named: "Setup")!, backgroundImage: nil, backgroundHighlightedImage: nil) {
            
            self.setUpFilter()
            
        }
        
        let logoutButton = ExpandingMenuItem(size: menuButtonSize, image: UIImage(named: "exitIcon")!, highlightedImage: UIImage(named: "exitIcon")!, backgroundImage: nil, backgroundHighlightedImage: nil) {
            
            self.logout()
            
        }


        
        
        
        menuButton.addMenuItems([mapButton, setupButton, logoutButton])
        menuButton.expandingDirection = .bottom
        
        
        
        
        
        
        
        Analytics.logEvent("Nearby_viewDidLoad", parameters: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupLayer()
    }
    
    deinit {
        
        print("LoadingViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        tabBarC?.fetchedLocations = self.locations
        tabBarC?.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        
        locationManager.stopUpdatingLocation()
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        tabBarC?.fetchedLocations = self.locations
        tabBarC?.userPhoto = self.userPhotoImageView
        
    }
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        return locations.count
        
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        let location = locations[index]
        
        if location.photo == nil {

            self.loadingNVAView.startAnimating()
            cell.imageView?.isHidden = true

        } else {
            self.loadingNVAView.stopAnimating()
            self.loadingNVAView.isHidden = true
            cell.imageView?.isHidden = false
            
            guard let storeImage = location.photo else {
                return FSPagerViewCell()
            }
            
            cell.imageView?.image = storeImage
            cell.imageView?.contentMode = .scaleAspectFill
            
        }
        
        storeDistanceLabel.text = location.distanceText
        storeDurationTimeLabel.text = location.durationText
        storeNameLabel.text = location.name
        
        choosedLocation = location
        
        var ifInTheList = false
        
        for locationInList in (tabBarC?.addLocations) ?? [] {
            
            if locationInList.name == choosedLocation.name {
                
                ifInTheList = true
                
            }
           
        }
        
        if ifInTheList == true {
            
            addToListButton.tintColor = UIColor.red
            
        } else {
            
            addToListButton.tintColor = UIColor.white.withAlphaComponent(0.7)
            
        }
        
        return cell

    }

    func addToList(_ sender: UIButton) {
        
        if sender.tintColor != UIColor.red {
            
            sender.tintColor = UIColor.red
            
            tabBarC?.addLocations.append(choosedLocation)

        } else {
            
            sender.tintColor = UIColor.white.withAlphaComponent(0.5)
            
            var nowAt = 0
            
            for location in (tabBarC?.addLocations) ?? [] {
                
                if location.name == choosedLocation.name {
                    tabBarC?.addLocations.remove(at: nowAt)
                }
                nowAt += 1
            }
        }
    }
    
       func showStoreDetail(_ sender: UIButton) {
        
        self.fetchPlaceIdDetailManager.requestPlaceIdDetail(locationsWithoutDetail: self.locations[sender.tag], senderTag: sender.tag)
        
    }

    
    func changTableViewAndMap() {
        if storeImagePagerView.isHidden == true {
            storeImagePagerView.isHidden = false
            storeImagePagerView.reloadData()
            mapView.isHidden = true
        } else {
            mapView.isHidden = false
            storeImagePagerView.isHidden = true
            self.storeImagePagerView.isHidden = true
        }
    }
    
    
    
    @IBAction func goToNavigation(_ sender: Any) {

        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?saddr=\(self.currentLocation.coordinate.latitude),\(self.currentLocation.coordinate.longitude)&daddr=\(self.choosedLocation.latitude),\(self.choosedLocation.longitude)&directionsmode=walking")!)
        } else {
            print("Can't use comgooglemaps://")
        }
        
    }

    
    func logout() {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Chalkboard SE", size: 25)!,
            kTextFont: UIFont(name: "Chalkboard SE", size: 16)!,
            kButtonFont: UIFont(name: "Chalkboard SE", size: 18)!,
            showCloseButton: false,
            showCircularIcon: true
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "exitIcon")
        
        alert.addButton("Sure", backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6), textColor: UIColor.white, showDurationStatus: false) {
            
            // 消去 UserDefaults內使用者的帳號資訊
            UserDefaults.standard.setValue(nil, forKey: "UserLoginEmail")
            UserDefaults.standard.setValue(nil, forKey: "UserLoginPassword")
            UserDefaults.standard.setValue(nil, forKey: "UID")
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.makeKeyAndVisible()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
            self.window?.rootViewController = loginVC
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addButton("Cancel", backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6), textColor: UIColor.white, showDurationStatus: false) {
            
            alert.dismiss(animated: true, completion: nil)
            
        }
        
        alert.showNotice("Logout", subTitle: "Are you sure?", circleIconImage: alertViewIcon)

        
    }
    

    func setUpFilter() {
        
        let distancePickerView = UIPickerView()
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Chalkboard SE", size: 25)!,
            kTextFont: UIFont(name: "Chalkboard SE", size: 16)!,
            kButtonFont: UIFont(name: "Chalkboard SE", size: 18)!,
            showCloseButton: false,
            showCircularIcon: true
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        // Creat the subview
        let subview = UIView(frame: CGRect(x: 0, y: 0, width: 180, height: 70))
        let x = (subview.frame.width - 180) / 2
        
        self.distanceTextField.frame = CGRect(x: x, y: 10, width: 108, height: 25)
        self.distanceTextField.text = String(self.distancePickOption[0])
        self.distanceTextField.font = UIFont(name: "Chalkboard SE", size: 18)
        distancePickerView.delegate = self
        self.distanceTextField.inputView = distancePickerView
        self.distanceTextField.textAlignment = .right
        subview.addSubview(distanceTextField)
        
        let distanceUnit = UILabel()
        distanceUnit.frame = CGRect(x: x + 108, y: 10, width: 108, height: 25)
        distanceUnit.text = "   M "
        distanceUnit.font = UIFont(name: "Chalkboard SE", size: 18)
        distanceUnit.textColor = UIColor.black
        distanceUnit.backgroundColor = UIColor.clear
        
        subview.addSubview(distanceUnit)
        
        let keywordTextField = UITextField(frame: CGRect(x: x + 15,
                                                         y: self.distanceTextField.frame.maxY + 10,
                                                         width: 180,
                                                         height: 25))
        keywordTextField.textAlignment = .center
        keywordTextField.placeholder = "Key words"
        
        subview.addSubview(keywordTextField)
        
        alert.customSubview = subview
        
        alert.addButton(" OK ",
                        backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6),
                        textColor: UIColor.white,
                        showDurationStatus: true) {
                            
                            self.filterDistance = Double(self.distanceTextField.text ?? "100") ?? 100
                            self.keywordText = (keywordTextField.text ?? "")
                            self.currentLocation = CLLocation()
                            self.lastLocation = nil
                            self.locations = []
                            self.nearbyLocationDictionary = [:]
                            self.storeNameLabel.text = ""
                            self.storeDistanceLabel.text = ""
                            self.storeDurationTimeLabel.text = ""
                            self.nextPageToken = ""
                            NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                                self.googleMapView.clear()
                                self.storeImagePagerView.reloadData()
                                self.locationManager.startUpdatingLocation()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                    
                                    self.locationManager.stopUpdatingLocation()
                                    
                                })
                                
                            })
        }
        
        alert.addButton(" Cancel ",
                        backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6),
                        textColor: UIColor.white,
                        showDurationStatus: true) {
                            
                            alert.dismiss(animated: true, completion: nil)
                            
        }
        
        alert.showInfo("SetUp", subTitle: "Define Range")
        
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
