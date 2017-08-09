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

class RandomGameViewController: UIViewController, MagneticDelegate, UITabBarControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var setSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var openSetRandomButton: FaveButton!
    
    @IBOutlet weak var distanceTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var keywordTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var randomCountTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var searchButton: FaveButton!
    
    @IBOutlet weak var setRandomView: UIView!
    
    @IBOutlet weak var addListCollectionView: UICollectionView!
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var navigationButton: FaveButton!
    
    
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
    
    var tabBarVC: MainTabBarController = MainTabBarController()

    var totalRestaurants = [Location]()
    var randomRestaurants = [Location]()
    var selectedRestaurant: Location?
    var searchedLocations = [Location]()
    var randomCount = 6
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var nodeDictionary = [String: String]()
    var nodes = [Node]()

    var colorArray: [UIColor] =
        [UIColor.red, UIColor.orange, UIColor.green, UIColor.blue, UIColor.purple, UIColor.brown]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchView.addSubview((searchController?.searchBar)!)
        view.addSubview(searchView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.barStyle = .blackTranslucent
        
        segmentedHandler()

        definesPresentationContext = true

        tabBarVC = self.tabBarController as? MainTabBarController ?? MainTabBarController()
        
        tabBarVC.delegate = self
        
        self.addListCollectionView.delegate = self
        self.addListCollectionView.dataSource = self
        
        
        // outlet fave button bug need to set two times color
        searchButton.isSelected = false
        openSetRandomButton.isSelected = false
        searchButton.normalColor = UIColor.asiSeaBlue
        openSetRandomButton.normalColor = UIColor.asiSeaBlue
        navigationButton.imageView?.contentMode = .scaleAspectFit
        navigationButton.isSelected = false
        navigationButton.normalColor = UIColor.asiBrownish

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // UI
        searchButton.isSelected = false
        searchButton.normalColor = UIColor.asiSeaBlue
        
        openSetRandomButton.isSelected = false
        openSetRandomButton.normalColor = UIColor.asiSeaBlue
        
        navigationButton.isSelected = false
        navigationButton.normalColor = UIColor.asiBrownish
        
        reloadRandomBallView()
        
    }
    
    func reloadRandomBallView() {
        
        self.addListCollectionView.reloadData()
        
        removeAllNode(magnetic: magnetic)
        
        self.randomRestaurants = []
        
        self.nodeDictionary = [:]
        
        if setSegmentedControl.selectedSegmentIndex == 0 {
        
            totalRestaurants = tabBarVC.fetchedLocations
            
        } else {
            
            
            totalRestaurants = tabBarVC.addLocations
            
            totalRestaurants.append(contentsOf: searchedLocations)
            
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
                radius: 30)
            
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
        
        nodes.append(node)
        
        magnetic.addChild(node)
        
    }
    
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        
        //消除其他已經選取的cell外框顏色
        for selectedNode in nodes {
            
            selectedNode.strokeColor = UIColor.clear
        
        }
        
        //加入外框顏色
        node.strokeColor = UIColor.red
        
        guard let key = node.text else {
            return
        }
        
        if nodeDictionary[key] != nil {
        
            node.text = nodeDictionary[key]
        }
        
        for selectedResraurant in self.randomRestaurants {
            
            if selectedResraurant.name == node.text {
                
                self.selectedRestaurant = selectedResraurant
                
            }
        }
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {

        self.selectedRestaurant = nil
        
    
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tabBarVC.addLocations.count + searchedLocations.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as? AddListCollectionViewCell else {
            return UICollectionViewCell()
        }
        if indexPath.row <= tabBarVC.addLocations.count && tabBarVC.addLocations.count != 0 {
            
            cell.locationLabel.text = tabBarVC.addLocations[indexPath.row].name
            
        } else {
            
            cell.locationLabel.text = searchedLocations[indexPath.row - tabBarVC.addLocations.count].name
            
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    @IBAction func randomSearch(_ sender: Any) {
        
        randomCount = Int(randomCountTextField.text!)!
        
        guard let distance = distanceTextField.text,
            let keyword = keywordTextField.text else {
                return
        }
        
        let nearbyViewController = tabBarVC.nearbyViewController as? NearbyViewController ?? NearbyViewController()
        
        nearbyViewController.filterDistance = Double(distance) ?? 0
        nearbyViewController.keywordText = keyword
        nearbyViewController.locations = []
        nearbyViewController.nearbyLocationDictionary = [:]
        nearbyViewController.lastLocation = nil
        nearbyViewController.locationManager.stopUpdatingLocation()
        nearbyViewController.locationManager.startUpdatingLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            
            nearbyViewController.mapTableView.reloadData()
            self.tabBarVC.fetchedLocations = nearbyViewController.locations
            
            self.reloadRandomBallView()
        }
    }
    
    
    @IBAction func openOrCloseSetRandomView(_ sender: FaveButton) {
        
        if setRandomView.isHidden == true {

            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.setRandomView.alpha = 1.0
                
                self.addListCollectionView.alpha = 1.0
                
            }, completion: { (_) in
                
                self.setRandomView.isHidden = false
                
                self.addListCollectionView.isHidden = false
                
            })

            
        } else {
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.setRandomView.alpha = 0.0
                
                self.addListCollectionView.alpha = 0.0
                
            }, completion: { (_) in
                
                self.setRandomView.isHidden = true
                
                self.addListCollectionView.isHidden = true
                
            })
            
        }
        
        
        
    }

    
    
    
    
    func segmentedHandler() {
        
        //如果selectedSegment有變更則用動畫的方式調整name 跟 phone的ishidden狀態
        if setSegmentedControl.selectedSegmentIndex == 0 {
            
            reloadRandomBallView()
            openSetRandomButton.isHidden = false
            searchView.isHidden = true
            addListCollectionView.isHidden = true
            setRandomView.isHidden = true
            
        } else {
            
            reloadRandomBallView()
            openSetRandomButton.isHidden = true
            searchView.isHidden = false
            addListCollectionView.isHidden = false
            setRandomView.isHidden = false
            
        }
        
    }
    @IBAction func goByNavigation(_ sender: UIButton) {
        
        let nearbyViewController = tabBarVC.nearbyViewController as? NearbyViewController ?? NearbyViewController()
        
        let startLocation = nearbyViewController.currentLocation
        
        guard let destinationLat = selectedRestaurant?.latitude,
                let destinationLon = selectedRestaurant?.longitude else {
                return
        }

        
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?saddr=\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)&daddr=\(destinationLat),\(destinationLon)&directionsmode=walking")!)
        } else {
            print("Can't use comgooglemaps://");
        }

    }

    @IBAction func setSegmentControl(_ sender: UISegmentedControl) {
        
        segmentedHandler()
    }

}
