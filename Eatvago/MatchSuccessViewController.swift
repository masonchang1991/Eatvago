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
import NVActivityIndicatorView
import SCLAlertView

//swiftlint:disable type_body_length
class MatchSuccessViewController: UIViewController, FSPagerViewDataSource, FSPagerViewDelegate, addOrRemoveListItemDelegate {
    
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var loadingNVAView: NVActivityIndicatorView!
    
    @IBOutlet weak var mapAndListChangeButton: UIButton!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var storeNameLabel: UILabel!

    @IBOutlet weak var addToListButton: UIButton!
    
    @IBOutlet weak var navigationButtonForList: UIButton!
    
    @IBOutlet weak var listPickerView: UIPickerView!
    
    @IBOutlet weak var listPickerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var changSearchStatusButton: UIButton!
    
    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var navigationButtonForPagerView: UIButton!
    
    @IBOutlet weak var chatBoxView: UIView!
    
    @IBOutlet weak var chatBoxTextField: UITextField!
    
    @IBOutlet weak var sendMessageButton: UIButton!
    
    @IBOutlet weak var matchRoomTableView: UITableView!
    
    @IBOutlet weak var titleBackgroundView: UIView!
    
    @IBOutlet weak var functionBarBackgroundView: UIView!
    
    @IBOutlet weak var underPagerViewBackgroundView: UIView!
    
    @IBOutlet weak var mainBackgroundView: UIView!

    @IBOutlet weak var listPagerView: FSPagerView! {
        
        didSet {
            
            self.listPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            
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
    
    var ref: DatabaseReference = DatabaseReference()
    
    var matchRoomRef = DatabaseReference()
    
    var matchSuccessRoomRef = DatabaseReference()
    
    var connectionRoomId = ""
    
    var myName = ""
    
    var oppositePeopleName = ""
    
    var isRoomOwner = false
    
    var type = ""
    
    var myPhotoImageView = UIImageView()
    
    var oppositePeopleImageView: UIImageView?
    
    var fetchRoomDataManager = FetchMatchSuccessRoomDataManager()
    
    var choosedLocation = ChoosedLocation(storeName: "", locationLat: "", locationLon: "")
    
    var pickerViewChoosedLocation = ChoosedLocation(storeName: "", locationLat: "", locationLon: "")
    
    var choosedLocations: [String: ChoosedLocation] = [:]
    
    var searchButtonStatus = false
    
    var chatRoomMessages: [Message] = []
    
    var messageSentFromMe = false
    
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
    
    //搜尋的地點
    var searchedLocations: [Location] = []
    
    //建立呼叫fetchNearbyLocation使用的location 用途：避免重複互叫fetchNearbyLocationManager
    var lastLocation: CLLocation?
    
    //建立location的字典 座標是key 值是location struct  目的: 改善地點間交集的狀況
    var nearbyLocationDictionary: [String : Location ] = [:]
    
    let fetchNearbyLocationManager = FetchNearbyLocationManager()
    let fetchPlaceIdDetailManager = FetchPlaceIdDetailManager()
    let fetchLocationImageManager = FetchLocationImageManager()
    let fetchDistanceManager = FetchDistanceManager()
    let addOrRemoveListItemManager = AddOrRemoveListItemManager()
    let sendMessageManager = SendMessageManager()
    let chatObserverManager = ChatObserverManager()
    
    var nextPageToken = ""
    
    var lastPageToken = ""
    
    var fetchPageCount = 0
    
    var myLocation = CLLocation()

    var resultsViewController: GMSAutocompleteResultsViewController?
    
    var searchController: UISearchController?
    
    var resultView: UITextView?
    
    var oppositePeoplePhoto: UIImage = UIImage()
    
    var window: UIWindow?
    
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
        
        ref = Database.database().reference()
        
        ifAnyoneDeclineObserver()
        
        ifAnyoneAddToList()
        
        self.fetchRoomDataManager.delegate = self
        
        self.fetchRoomDataManager.fetchRoomData(matchSuccessRoomRef: matchSuccessRoomRef)
        
        resultsViewController = GMSAutocompleteResultsViewController()
        
        resultsViewController?.delegate = self
    
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
        addOrRemoveListItemManager.delegate = self
        sendMessageManager.delegate = self
        chatObserverManager.delegate = self
        
        //配置pagerView
        
        self.listPagerView.delegate = self
        
        self.listPagerView.dataSource = self
        
        //配置pickerview
        
        self.listPickerView.delegate = self
        
        self.listPickerView.dataSource = self
        
        //配置navigation button action
        self.navigationButtonForPagerView.addTarget(self,
                                                    action: #selector(navigationForPagerView),
                                                    for: .touchUpInside)
        
        self.navigationButtonForList.addTarget(self,
                                               action: #selector(navigationForList),
                                               for: .touchUpInside)
        
        //設置聊天室observer
        chatObserverManager.setObserver(connectionRoomId: connectionRoomId)
        
        //tableview
        self.matchRoomTableView.delegate = self
        
        self.matchRoomTableView.dataSource = self
        
        self.matchRoomTableView.estimatedRowHeight = 300
        
        self.matchRoomTableView.rowHeight = UITableViewAutomaticDimension
        
        //buttonFunction
        self.changSearchStatusButton.addTarget(self, action: #selector(searchStatusHandler), for: .touchUpInside)
        
        self.sendMessageButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        //layout
        layoutSet()
        
        //keyboard收下去
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(self.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        UIApplication.shared.isStatusBarHidden = true
        
        Analytics.logEvent("MatchSuccessRoom_viewDidLoad", parameters: nil)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        locationManager.stopUpdatingLocation()
        
        setLayer()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        
        locationManager.stopUpdatingLocation()
        
        googleMapView = nil
        
        placesClient = nil
        
        ref.removeAllObservers()
        
        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }
    
    func sendMessage() {
        
        if chatBoxTextField.text?.characters.count == 0 || chatBoxTextField.text == ""{
            
            return
            
        } else {
            
            guard let message = chatBoxTextField.text else { return }
            
            sendMessageManager.sendMessageToFireBase(message: message,
                                                     connectionRoomId: connectionRoomId)
            
            self.chatBoxTextField.text = ""
            
        }
        
    }
    
    func navigationForPagerView() {
        
        Analytics.logEvent("MatchSuccessRoom_navigationForPagerView", parameters: nil)
        
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?saddr=\(self.myLocation.coordinate.latitude),\(self.myLocation.coordinate.longitude)&daddr=\(choosedLocation.locationLat),\(choosedLocation.locationLon)&directionsmode=walking")!)
            
        } else {
            
            print("Can't use comgooglemaps://")
            
            //Todo: Error handling
            
        }
        
    }
    
    func navigationForList() {
        
        Analytics.logEvent("MatchSuccessRoom_navigationForList", parameters: nil)
        
        let appearance = SCLAlertView.SCLAppearance(
            
            kTitleFont: UIFont(name: "Chalkboard SE", size: 25)!,
            kTextFont: UIFont(name: "Chalkboard SE", size: 16)!,
            kButtonFont: UIFont(name: "Chalkboard SE", size: 18)!,
            showCloseButton: false,
            showCircularIcon: false
            
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("Walking", backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6), textColor: UIColor.white, showDurationStatus: false) {
            
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                
                UIApplication.shared.openURL(URL(string:
                    "comgooglemaps://?saddr=\(self.myLocation.coordinate.latitude),\(self.myLocation.coordinate.longitude)&daddr=\(self.pickerViewChoosedLocation.locationLat),\(self.pickerViewChoosedLocation.locationLon)&directionsmode=walking")!)
                
            } else {
                
                print("Can't use comgooglemaps://")
                //Todo: Error handling
                
            }
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addButton("bicycling", backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6), textColor: UIColor.white, showDurationStatus: false) {
            
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                
                UIApplication.shared.openURL(URL(string:
                    "comgooglemaps://?saddr=\(self.myLocation.coordinate.latitude),\(self.myLocation.coordinate.longitude)&daddr=\(self.pickerViewChoosedLocation.locationLat),\(self.pickerViewChoosedLocation.locationLon)&directionsmode=bicycling")!)
                
            } else {
                
                print("Can't use comgooglemaps://")
                //Todo: Error handling
                
            }
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addButton("driving", backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6), textColor: UIColor.white, showDurationStatus: false) {
            
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                
                UIApplication.shared.openURL(URL(string:
                    "comgooglemaps://?saddr=\(self.myLocation.coordinate.latitude),\(self.myLocation.coordinate.longitude)&daddr=\(self.pickerViewChoosedLocation.locationLat),\(self.pickerViewChoosedLocation.locationLon)&directionsmode=driving")!)
                
            } else {
                
                print("Can't use comgooglemaps://")
                //Todo: Error handling
                
            }
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addButton("Cancel", backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6), textColor: UIColor.white, showDurationStatus: false) {
            
            alert.dismiss(animated: true, completion: nil)
            
        }

        alert.showEdit("Transit Mode", subTitle: "Choose")
        
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
        
        durationLabel.text = location.durationText
        
        distanceLabel.text = location.distanceText
        
        storeNameLabel.text = location.name
        
        choosedLocation = ChoosedLocation(storeName: location.name,
                                          locationLat: String(location.latitude),
                                          locationLon: String(location.longitude))
        //將location存入
        
        if self.choosedLocations[self.choosedLocation.storeName] != nil {
            
            self.addToListButton.imageView?.image = UIImage(named: "addListHeart")
            
        } else {
            
            self.addToListButton.imageView?.image = UIImage(named: "bigHeart")
            
        }
        
        return cell
    }
    
    func ifAnyoneDeclineObserver() {
        
        Analytics.logEvent("MatchSuccessRoom_IfAnyoneDeclineObserver", parameters: nil)
        
        matchRoomRef.child("isClosed").observe(.value, with: { (snapshot) in
            
            guard let isClosed = snapshot.value as? Bool else { return }
            
            if isClosed == true {
                
                let alertController = UIAlertController(
                    title: "Sorry",
                    message: "You have been declined",
                    preferredStyle: .alert)
                
                let okAction = UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.default) { (_: UIAlertAction!) -> Void in
                        
                        guard let uid = Auth.auth().currentUser?.uid else { return }

                        self.locationManager.stopUpdatingLocation()
                        
                        self.ref.child("UserHistory").child(uid).child(self.connectionRoomId).removeValue()
                        
                        self.matchRoomRef.child("isClosed").removeAllObservers()
                        
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
    
    func ifAnyoneAddToList() {
        
        self.matchSuccessRoomRef.child("list").observe(.value, with: { (snapshot) in
            
            self.choosedLocations = [:]
            
            guard let locations = snapshot.value as? [String: [String: String]] else {
                
                self.setupPickerView()
                
                self.listPickerView.reloadAllComponents()
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                return
            }
            
            for (_, location) in locations {
                
                let storeName = location["storeName"]
                
                let locationLat = location["locationLat"]
                
                let locationLon = location["locationLon"]
                
                self.choosedLocations[storeName ?? ""] = ChoosedLocation(storeName: storeName ?? "",
                                                                         locationLat: locationLat ?? "",
                                                                         locationLon: locationLon ?? "")
                
            }
            
            self.listPagerView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                
                self.setupPickerView()
                
                self.listPickerView.reloadAllComponents()
                
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
            })
        })
    }
    
    func setupPickerView() {
            
            if self.choosedLocations.count + self.searchedLocations.count == 0 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.listPickerHeightConstraint.constant = 0
                    
                    self.view.layoutIfNeeded()
                    
                }, completion: { (_) in
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                        
                        self.listPickerView.isHidden = true
                        
                        self.navigationButtonForList.isHidden = true
                        
                    })
                    
                })
                
            } else {
                
                UIView.animate(withDuration: 0.01, animations: {
                    
                    self.listPickerView.isHidden = false
                    
                    self.navigationButtonForList.isHidden = false
                    
                }, completion: { (_) in
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        
                        self.listPickerHeightConstraint.constant = 100
                        
                        self.view.layoutIfNeeded()
                    })
                    
                })
            }
        
    }

    func manager(_ manager: AddOrRemoveListItemManager, successAdded: Bool) {
        
        //successAdded 若 = false 則為remove
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
    }
    
    func manager(_ manager: AddOrRemoveListItemManager, didFail withError: String) {
        
        let appearance = SCLAlertView.SCLAppearance(
            
            kTitleFont: UIFont(name: "Chalkboard SE", size: 25)!,
            kTextFont: UIFont(name: "Chalkboard SE", size: 16)!,
            kButtonFont: UIFont(name: "Chalkboard SE", size: 18)!,
            showCloseButton: false,
            showCircularIcon: false
            
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("OK", backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6), textColor: UIColor.white, showDurationStatus: false) {
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.showError("Error", subTitle: withError)
        
    }
    
    @IBAction func addToList(_ sender: Any) {
        
        self.addOrRemoveListItemManager.addOrRemovelistItem(matchSuccessRoomRef: matchSuccessRoomRef,
                                                            choosedLocation: self.choosedLocation)
        
    }

    func searchStatusHandler() {
        
        //如果searchStatus有變更
        if searchButtonStatus == false {
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.searchBarHeightConstraint.constant = 0
                
                self.view.layoutIfNeeded()
                
                self.searchBarView.alpha = 0.0
                
            }, completion: { (_) in
                
                self.searchBarView.isHidden = true
                
                self.searchButtonStatus = true
                
                DispatchQueue.main.async {
                    
                    self.changSearchStatusButton.imageView?.image = UIImage(named: "openSearch")
                    
                }
            })
            
        } else {
            
            self.searchBarView.isHidden = false
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.searchBarView.alpha = 1.0
                
                self.searchBarHeightConstraint.constant = 40
                
                self.view.layoutIfNeeded()
                
            }, completion: { (_) in

                self.searchButtonStatus = false
                
                DispatchQueue.main.async {
                    
                    self.changSearchStatusButton.imageView?.image = UIImage(named: "closeSearch")
                    
                }
            })
            
        }
        
    }
    
    @IBAction func mapAndListChange(_ sender: Any) {
        
        if mapView.isHidden == true {
            
            mapView.isHidden = false
            
            listPagerView.isHidden = true
            
            loadingNVAView.isHidden = true
            
        } else {
            
            mapView.isHidden = true
            
            listPagerView.isHidden = false
            
            loadingNVAView.isHidden = false
            
        }
        
    }

    @IBAction func leaveChatRoom(_ sender: Any) {
        
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
        
        alert.addButton("Sure",
                        backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6),
                        textColor: UIColor.white,
                        showDurationStatus: false) {
            
            self.locationManager.stopUpdatingLocation()
            
            self.removeFromParentViewController()
            
            self.dismiss(animated: true, completion: nil)

            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addButton("Cancel",
                        backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6),
                        textColor: UIColor.white,
                        showDurationStatus: false) {
            
            alert.dismiss(animated: true, completion: nil)
            
        }
        
        alert.showNotice("Leave", subTitle: "Are you sure ?", circleIconImage: alertViewIcon)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
