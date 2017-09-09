//
//  RandomGameViewController.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/2.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//
import Foundation
import UIKit
import Magnetic
import SpriteKit
import SkyFloatingLabelTextField
import GooglePlaces
import FaveButton
import GoogleMaps
import GooglePlacePicker
import NVActivityIndicatorView
import Firebase

class RandomGameViewController: UIViewController, MagneticDelegate, UITabBarControllerDelegate {
    
    @IBOutlet weak var distanceTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var keywordTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var randomCountTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var searchButton: FaveButton!
    
    @IBOutlet weak var setRandomView: UIView!
    
    @IBOutlet weak var navigationButton: FaveButton!
    
    @IBOutlet weak var randomGameBackgorundImageView: UIImageView!

    @IBOutlet weak var randomGameMagneticView: MagneticView! {
        didSet {
            magnetic.magneticDelegate = self
            #if DEBUG
                randomGameMagneticView.showsFPS = false
                randomGameMagneticView.showsDrawCount = false
                randomGameMagneticView.showsQuadCount = false
            #endif
        }
    }
    
    var magnetic: Magnetic {
        return randomGameMagneticView.magnetic
    }
    
    weak var tabBarVC: MainTabBarController?
    
    var totalRestaurants = [Location]()
    var randomRestaurants = [Location]()
    var selectedRestaurant: Location?
    var searchedLocations = [Location]()
    var randomCount = 6
    
    weak var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var nodeDictionary = [String: String]()
    var nodes = [Node]()

    var colorArray: [UIColor] =
        [UIColor.asiSlate.withAlphaComponent(0.6),
         UIColor.asiSeaBlue.withAlphaComponent(0.6),
         UIColor.asiSandBrown.withAlphaComponent(0.6),
         UIColor.asiDustyOrange.withAlphaComponent(0.6),
         UIColor.asiBrownish.withAlphaComponent(0.6),
         UIColor.asiDarkishBlue.withAlphaComponent(0.6),
         UIColor.asiGreyishBrown.withAlphaComponent(0.6),
         UIColor.asiPaleGold.withAlphaComponent(0.6),
         UIColor.asiCharcoalGrey.withAlphaComponent(0.6)]
    
     var distancePickOptions = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
     var randomCountPickOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
     var distancePickerView = UIPickerView()
     var randomCountPickerView = UIPickerView()
    
    let activityData = ActivityData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarVC = self.tabBarController as? MainTabBarController
        tabBarVC?.delegate = self
        
        // picker view
        distancePickerView.delegate = self
        self.distanceTextField.inputView = distancePickerView
        self.distanceTextField.text = "\(distancePickOptions[4])"
        distancePickerView.selectRow(4, inComponent: 0, animated: false)
        randomCountPickerView.delegate = self
        self.randomCountTextField.inputView = randomCountPickerView
        self.randomCountTextField.text = "\(randomCountPickOptions[5])"
        self.randomCountPickerView.selectRow(5, inComponent: 0, animated: false)
        
        // keyboard 收下去
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        self.view.addGestureRecognizer(tap)
        
        Analytics.logEvent("RandomGame_viewDidLoad", parameters: nil)
        
    }
    
    deinit {
        print("RandomViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // UI
        setLayout()
  
        reloadRandomBallView()
        
        self.navigationButton.isSelected = true
        self.navigationButton.isSelected = false
        self.navigationButton.tintColor = UIColor.white
        self.navigationButton.isUserInteractionEnabled = false
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func reloadRandomBallView() {

        removeAllNode(magnetic: magnetic)
        
        self.randomRestaurants = []
        
        self.nodeDictionary = [:]

        totalRestaurants = (tabBarVC?.fetchedLocations) ?? []
        
        if totalRestaurants.count == 0 {
            return
        }
        
        randomGameMagneticView.presentScene(magnetic)

        generateRandomRetaurant(randomCounts: randomCount, totalRestaurants: totalRestaurants)
        
        var progressCount = 0
        var colorProgressCount = 0
        for restaurant in self.randomRestaurants {
            
            progressCount += 1
            
            self.nodeDictionary["\(progressCount)"] = restaurant.name
            
            addNode(magnetic: magnetic,
                    text: "\(progressCount)",
                image: restaurant.photo,
                color: colorArray[colorProgressCount],
                radius: UIScreen.main.bounds.width / 7)
            
            //避免count超過color array長度
            if colorProgressCount == (colorArray.count - 1) {
                
                colorProgressCount = 0
                
            } else {
                
                colorProgressCount += 1
                
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }

    func generateRandomRetaurant(randomCounts: Int, totalRestaurants: [Location]) {
        
        if totalRestaurants.count == 0 { return }
        
        let upperBound = totalRestaurants.count
        
        var randomRestaurantsCount = 0
        
        var randomRestaurantsObserver: [String: String] = [:]
        
        while randomRestaurantsCount != randomCounts && randomRestaurantsCount != totalRestaurants.count {
            
            let randomNumner = Int(arc4random_uniform(UInt32(upperBound)))
            
            if randomRestaurantsObserver[totalRestaurants[randomNumner].name] == nil {
                
                self.randomRestaurants.append(totalRestaurants[randomNumner])
                
                randomRestaurantsObserver["\(totalRestaurants[randomNumner].name)"] = totalRestaurants[randomNumner].name
                
                randomRestaurantsCount += 1
                
            } else {
                
            }
        }
    }
    
    func removeAllNode(magnetic: Magnetic) {
        
        for node in nodes {
            
            node.removeFromParent()
        }
    }
    
    func addNode(magnetic: Magnetic, text: String, image: UIImage?, color: UIColor, radius: CGFloat) {
        
        let node = Node(text: text, image: image, color: color, radius: radius)
        node.label.fontSize = 35
        nodes.append(node)
        
        magnetic.addChild(node)
        
    }
    
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        
        self.navigationButton.isUserInteractionEnabled = true
        self.navigationButton.normalColor = UIColor.asiSeaBlue.withAlphaComponent(0.6)
        self.navigationButton.isSelected = false
        //消除其他已經選取的cell外框顏色
        for selectedNode in nodes {
            
            selectedNode.strokeColor = UIColor.clear
            
        }
        
        magnetic.allowsMultipleSelection = false
        //加入外框顏色
        node.strokeColor = UIColor.red
        
        guard let key = node.text else {
            return
        }
        
        if nodeDictionary[key] != nil {
            
            if (nodeDictionary[key]?.characters.count)! > 7 {
                
                node.label.fontSize = 10
                
            } else {
                node.label.fontSize = 15
            }
            node.text = nodeDictionary[key]
            node.label.fontName = "Chalkboard SE"
        }
        
        for selectedResraurant in self.randomRestaurants where selectedResraurant.name == node.text {
            
                self.selectedRestaurant = selectedResraurant
             
        }
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {

        self.selectedRestaurant = nil
        self.navigationButton.isUserInteractionEnabled = false
        self.navigationButton.normalColor = UIColor.white
        self.navigationButton.isSelected = false
    
    }

    @IBAction func randomSearch(_ sender: Any) {
        
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        if randomCountTextField.text?.characters.count == 0
            || distanceTextField.text?.characters.count == 0 {
            
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                return
        }
        
        randomCount = Int(randomCountTextField.text ?? "0") ?? 0
        
        guard let distance = distanceTextField.text,
            let keyword = keywordTextField.text else {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                return
        }
        
        guard let nearbyViewController = tabBarVC?.nearbyViewController as? NearbyViewController else {
            return
        }
        
        nearbyViewController.filterDistance = Double(distance) ?? 0
        nearbyViewController.keywordText = keyword
        nearbyViewController.locations = []
        nearbyViewController.nearbyLocationDictionary = [:]
        nearbyViewController.lastLocation = nil
        nearbyViewController.locationManager.stopUpdatingLocation()
        nearbyViewController.locationManager.startUpdatingLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            
            nearbyViewController.storeImagePagerView.reloadData()
            self.tabBarVC?.fetchedLocations = nearbyViewController.locations
            
            self.reloadRandomBallView()
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            nearbyViewController.locationManager.stopUpdatingLocation()
        }
    }
    
    @IBAction func goByNavigation(_ sender: UIButton) {
        
        let nearbyViewController = tabBarVC?.nearbyViewController as? NearbyViewController ?? NearbyViewController()
        
        let startLocation = nearbyViewController.currentLocation
        
        guard let destinationLat = selectedRestaurant?.latitude,
                let destinationLon = selectedRestaurant?.longitude else {
                return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                UIApplication.shared.openURL(URL(string:
                    "comgooglemaps://?saddr=\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)&daddr=\(destinationLat),\(destinationLon)&directionsmode=walking")!)
                
                self.navigationButton.isSelected = false
                
            } else {
                print("Can't use comgooglemaps://")
                
                self.navigationButton.isSelected = false
            }
            
        }
    }
}
