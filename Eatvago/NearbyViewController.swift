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
import YNDropDownMenu

var filterText = ""

class NearbyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var mapTableView: UITableView!
    var window: UIWindow?
    //Declare the location manager, current location, map view, places client, and default zoom level at the class level
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var googleMapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 18.0
    var filterDistance = 100.0

    
    //附近的地點 base on mylocation
    var locations: [Location] = []
    
    //建立呼叫fetchNearbyLocation使用的location 用途：避免重複互叫fetchNearbyLocationManager
    var lastLocation: CLLocation?
    
    //建立location的字典 座標是key 值是location struct  目的: 改善地點間交集的狀況
    var nearbyLocationDictionary: [String : Location ] = [:]
    
    let fetchNearbyLocationManager = FetchNearbyLocationManager()
    let fetchPlaceIdDetailManager = FetchPlaceIdDetailManager()
    let fetchPlaceImageManager = FetchPlaceImageManager()
    let fetchDistanceManager = FetchDistanceManager()
    var nextPageToken = ""
    var lastPageToken = ""
    var fetchPageCount = 0
    
    //用來add資訊
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
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
        
        // 配置 locationManager
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        

        mapTableView.delegate = self
        mapTableView.dataSource = self
        
        fetchNearbyLocationManager.delegate = self
        fetchPlaceIdDetailManager.delegate = self
        fetchPlaceImageManager.delegate = self
        fetchDistanceManager.delegate = self

        ref = Database.database().reference()
        

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        self.lastLocation = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //讀取圖片func
    func loadFirstPhotoForPlace(placeID: String, indexPathRow: Int) {
        print(placeID)
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto, indexPathRow: indexPathRow)
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata, indexPathRow: Int) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.locations[indexPathRow].photo = photo
                    self.mapTableView.reloadData()
                }
            }
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mapTableViewCell", for: indexPath) as? NearbyMapTableViewCell else {
            return UITableViewCell()
        }
        let location = locations[indexPath.row]
        
        cell.mapTextLabel.text = location.name
        
        if location.photo == nil {
            cell.storePhotoView.startAnimating()
            cell.storePhotoImageView.isHidden = true
            
        } else {
            cell.storePhotoView.isHidden = true
            cell.storePhotoImageView.isHidden = false
            cell.storePhotoView.stopAnimating()
            
            guard let storeImage = location.photo else {
                return UITableViewCell()
            }
            cell.storePhotoImageView.image = storeImage
            cell.storePhotoImageView.contentMode = .scaleToFill
        }
        cell.showStoreDetailButton.tag = indexPath.row
        cell.showStoreDetailButton.addTarget(self, action: #selector(showStoreDetail(_:)), for: .touchUpInside)
        cell.addStoreDetailButton.tag = indexPath.row
        cell.addStoreDetailButton.addTarget(self, action: #selector(addStoreDetail(_:)), for: .touchUpInside)
        
        cell.distanceText.text = location.distanceText
        cell.durationText.text = location.durationText
    
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
    
    func addStoreDetail(_ sender: UIButton) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 15)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 10)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        let subTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 216, height: 70))
        let x = (subTextField.frame.width - 180) / 2
        
        let addCommentTextField = UITextField(frame: CGRect(x: x, y: 10, width: 180, height: 50))
        
        addCommentTextField.layer.borderColor = UIColor.blue.cgColor
        addCommentTextField.layer.borderWidth = 1.5
        addCommentTextField.layer.cornerRadius = 5
        addCommentTextField.placeholder = " 施工中"
        subTextField.addSubview(addCommentTextField)
        alert.customSubview = subTextField

        
        alert.addButton("OK") {
            
            var text = addCommentTextField.text
            
            let autoId = self.ref?.childByAutoId()
            
            guard let key = autoId?.key else {
                return
            }
            
            
            self.ref?.child("Place Detail").child("\(self.locations[sender.tag].placeId)").child("Comments").child(key).setValue(key)
            
            self.ref?.child("Comments").child("\(self.locations[sender.tag].placeId)").child(key).child("Creater").setValue(userId)
            
            self.ref?.child("Comments").child("\(self.locations[sender.tag].placeId)").child(key).child("Comment").setValue(text)
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.showTitle("評論\(self.locations[sender.tag].name)", subTitle: "", style: .success)
      
        
        
        
        
    }
    
    
    
    func showStoreDetail(_ sender: UIButton) {
        
        self.fetchPlaceIdDetailManager.requestPlaceIdDetail(locationsWithoutDetail: self.locations[sender.tag], senderTag: sender.tag)
        
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

    @IBAction func chaneDistance(_ sender: Any) {
        
        locationManager.stopUpdatingLocation()
        
        
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "切換距離",
            message: "請輸入您要的距離",
            preferredStyle: .alert)
        
        // 建立一個輸入框
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "距離"
        }
        
        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)

        // 建立[登入]按鈕
        let okAction = UIAlertAction(
            title: "確認",
            style: UIAlertActionStyle.default) {
                (action: UIAlertAction!) -> Void in
                
                self.filterDistance = Double((alertController.textFields?.first?.text)!)!
                self.currentLocation = CLLocation()
                self.lastLocation = nil
                self.locations = []
                fetchedLocations = []
                self.nearbyLocationDictionary = [:]
                DispatchQueue.main.async {
                    self.googleMapView.clear()
                    self.mapTableView.reloadData()
                    self.locationManager.startUpdatingLocation()
                }

                
        }
        alertController.addAction(okAction)
        self.present(
            alertController,
            animated: true,
            completion: nil)
        
    }
   
    @IBAction func textFilter(_ sender: Any) {
        
        locationManager.stopUpdatingLocation()
        
        
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "輸入關鍵字",
            message: "請輸入您的關鍵字",
            preferredStyle: .alert)
        
        // 建立一個輸入框
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "Key word"
        }
        
        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)
        
        // 建立[登入]按鈕
        let okAction = UIAlertAction(
            title: "確認",
            style: UIAlertActionStyle.default) {
                (action: UIAlertAction!) -> Void in
                
                filterText = (alertController.textFields?.first?.text)!
                self.currentLocation = CLLocation()
                self.lastLocation = nil
                self.locations = []
                fetchedLocations = []
                self.nearbyLocationDictionary = [:]
                DispatchQueue.main.async {
                    self.googleMapView.clear()
                    self.mapTableView.reloadData()
                    self.locationManager.startUpdatingLocation()
                }
                
                
        }
        alertController.addAction(okAction)
        self.present(
            alertController,
            animated: true,
            completion: nil)
        
    }
    
}
