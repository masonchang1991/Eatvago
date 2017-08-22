//
//  AddedRandomViewController.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/21.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import GooglePlaces

class AddedRandomViewController: UIViewController, UITabBarControllerDelegate {

    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var addListPickerView: UIPickerView!
    
    @IBOutlet weak var ifAddFavoriteListButton: UIButton!

    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var navigationButton: UIButton!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // google autocomplete search
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    // search後的地點存入
    var searchedLocations = [Location]()
    
    // tabbar傳值
    weak var tabBarVC: MainTabBarController?
    
    // 判斷是否加入FavoriteList進入button
    var ifAddFavoriteList = true
    
    //讓pickerview能旋轉一定大的數量
    var maxRows = 10
    var maxElements = 10000
    var currentRow = 0
    var currentLocation = Location(latitude: 0.0, longitude: 0.0, name: "", id: "", placeId: "", types: [], priceLevel: nil, rating: nil, photoReference: "")
    var movingTimer = Timer()
    var stepper = 1
    
    var colorArray: [UIColor] =
        [UIColor.asiSlate,
         UIColor.asiSeaBlue,
         UIColor.asiSandBrown,
         UIColor.asiDustyOrange,
         UIColor.asiBrownish,
         UIColor.asiDarkishBlue,
         UIColor.asiGreyishBrown,
         UIColor.asiPaleGold,
         UIColor.asiCharcoalGrey]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarVC = self.tabBarController as? MainTabBarController
        tabBarVC?.delegate = self
        
        self.addListPickerView.delegate = self
        self.addListPickerView.dataSource = self
        self.addListPickerView.selectRow(maxElements / 2, inComponent: 0, animated: false)

        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self

        //layout
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchView.addSubview((searchController?.searchBar)!)
        view.addSubview(searchView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.searchBar.barStyle = .default
        let searchBarColor = UIColor(red: 255.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 0.8)
        searchController?.searchBar.barTintColor = searchBarColor
        definesPresentationContext = true
        
        setLayout()

        self.playButton.addTarget(self, action: #selector(movePicker), for: .touchUpInside)
        self.navigationButton.addTarget(self, action: #selector(goByNavigation), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        setLayout()
        self.addListPickerView.reloadAllComponents()
        
    }
    
    func movePicker() {
       
        navigationButton.isEnabled = false
        
        let timer1 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(scrollToRandomRowFirst), userInfo: nil, repeats: true)
        
        //call the block 3 seconds later
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
            
            timer1.invalidate()
            
            self.stepper = 2
            
            let timer2 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToRandomRowFirst), userInfo: nil, repeats: true)
            
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                    
                    timer2.invalidate()
                    
                    self.stepper = 4
                    
                    let timer3 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToRandomRowFirst), userInfo: nil, repeats: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                    
                        timer3.invalidate()
                        
                        self.stepper = 6
                        
                        let timer4 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToRandomRowFirst), userInfo: nil, repeats: true)
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                            
                            timer4.invalidate()
                            
                            self.stepper = 8
                            
                            let timer5 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToRandomRowFirst), userInfo: nil, repeats: true)
                            
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                                
                                timer5.invalidate()
                                
                                self.stepper = 10
                                
                                let timer6 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToRandomRowFirst), userInfo: nil, repeats: true)
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                                    
                                    timer6.invalidate()
                                    
                                    self.stepper = 12
                                    
                                    let timer7 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToRandomRowFirst), userInfo: nil, repeats: true)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                                        
                                        timer7.invalidate()
                                        
                                        
                                        let timer8 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToRandomRowThird), userInfo: nil, repeats: true)
                                        
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                                            
                                            timer8.invalidate()
                                            
                                            self.stepper = 12
                                            
                                            let timer9 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToRandomRowFirst), userInfo: nil, repeats: true)
                                            
                                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                                                
                                                timer9.invalidate()
                                                
                                                self.stepper = 10
                                                
                                                let timer10 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToRandomRowFirst), userInfo: nil, repeats: true)
                                                
                                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 / 2*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                                                    
                                                    timer10.invalidate()
                                                    
                                                    self.stepper = 8
                                                    
                                                    let timer11 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToRandomRowFirst), userInfo: nil, repeats: true)
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 / 2*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                                                        
                                                        timer11.invalidate()
                                                        
                                                        self.stepper = 6
                                                        
                                                        let timer11 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToRandomRowFirst), userInfo: nil, repeats: true)
                                                        
                                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 / 2*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                                                            
                                                            timer11.invalidate()
                                                            
                                                            self.stepper = 4
                                                            
                                                            let timer12 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToRandomRowFirst), userInfo: nil, repeats: true)
                                                            
                                                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                                                                
                                                                timer12.invalidate()
                                                                
                                                                self.stepper = 2
                                                                
                                                                let timer13 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToRandomRowFirst), userInfo: nil, repeats: true)
                                                                
                                                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                                                                    
                                                                    timer13.invalidate()
                                                           
                                                                    self.stepper = 1
                                                                    
                                                                    let timer14 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollToRandomRowFirst), userInfo: nil, repeats: true)
                                                                    
                                                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                                                                        
                                                                        timer14.invalidate()
                                                                        self.navigationButton.isEnabled = true
                                                                        
                                                                    }
                                                                    
                                                                    
                                                                }
                                                                
                                                                
                                                                
                                                            }
                                                            
                                                            
                                                            
                                                        }

                                                        
                                                    }

                                                }

                                                
                                            }
                                            
                                            
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    
                                    
                                }

                                
                                
                                
                            }

                            
                            
                            
                        }

                        
                        
                    }
                    
            }

            
        }


        
    }
    
    
    func scrollToRandomRowFirst() {
        
        
        if currentRow + 3000 > maxElements {
            
            maxElements += maxElements
            
        }
        
        
        let addRow = stepper
        
        self.currentRow += addRow
        self.fetchPickerNowLocation(currentRow: self.currentRow)
        self.addListPickerView.selectRow(self.currentRow, inComponent: 0, animated: true)
        self.addListPickerView.showsSelectionIndicator = true
        
    }
    
    func scrollToRandomRowThird() {
        
        let addRow = 12
        let randomAddRow = Int(arc4random_uniform(2))
        
        self.currentRow += addRow
        self.currentRow += randomAddRow
        
        self.addListPickerView.selectRow(self.currentRow, inComponent: 0, animated: true)
        self.addListPickerView.showsSelectionIndicator = true
        
    }
    
    func fetchPickerNowLocation(currentRow row: Int) {
        
        if ifAddFavoriteList == true {
            
            if (tabBarVC?.addLocations.count)! + searchedLocations.count == 0 {
                return
            }
            
            
            if let addLocationCount = tabBarVC?.addLocations.count {
                
                maxRows = addLocationCount + searchedLocations.count
                
                let myRow = row % maxRows
                
                if myRow < addLocationCount && addLocationCount != 0 {
                    
                    self.currentLocation = tabBarVC?.addLocations[myRow] ?? self.currentLocation
                    
                } else {
                    
                    self.currentLocation = searchedLocations[myRow - addLocationCount]
                    
                }
                
            }
            
        } else {
            
            if searchedLocations.count == 0 {
                return
            }
            
            maxRows = searchedLocations.count
            
            let myRow = row % maxRows
            
            self.currentLocation = searchedLocations[myRow]
            
        }
        
    }
    
    

    func goByNavigation() {
        
        let nearbyViewController = tabBarVC?.nearbyViewController as? NearbyViewController ?? NearbyViewController()
        
        let startLocation = nearbyViewController.currentLocation
        
        let destinationLat = self.currentLocation.latitude
        let destinationLon = self.currentLocation.longitude
    
        
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?saddr=\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)&daddr=\(destinationLat),\(destinationLon)&directionsmode=walking")!)
        } else {
            print("Can't use comgooglemaps://")
        }

    }
    
    

    @IBAction func changAddFavoriteState(_ sender: Any) {
        
        if ifAddFavoriteList == true {
            
            self.ifAddFavoriteListButton.imageForNormal = UIImage(named: "check")
            
            ifAddFavoriteList = false
            addListPickerView.reloadAllComponents()
            
            
        } else {
            
            self.ifAddFavoriteListButton.imageForNormal = UIImage(named: "uncheck")
            
            ifAddFavoriteList = true
            addListPickerView.reloadAllComponents()
            
        }
        
        
        
    }
    
    
 
}
