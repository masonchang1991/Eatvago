//
//  NearbyMenuFunction.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/25.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import SCLAlertView
import CoreLocation
import NVActivityIndicatorView

extension NearbyViewController {
    
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
        
        self.distanceTextField.text = String(self.distancePickOption[4])
        
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
                            
                            if self.keywordText.characters.count == 0 {
                                
                                self.settingLabel.text = " Radius: \(self.filterDistance) M \n Keyword: None "
                                
                            } else {
                                
                                self.settingLabel.text = " Radius: \(self.filterDistance) M \n Keyword: \(self.keywordText) "
                                
                            }
                            
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

    func setUpProfile() {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Chalkboard SE", size: 25)!,
            kTextFont: UIFont(name: "Chalkboard SE", size: 16)!,
            kButtonFont: UIFont(name: "Chalkboard SE", size: 18)!,
            showCloseButton: false,
            showCircularIcon: false
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        userProfileAlertView = alert
        
        // Creat the subview
        let width = 216
        
        let subview = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 115))
        
        self.userPhotoImageView.frame = CGRect(x: subview.frame.width / 2 - 50,
                                               y: 15, width: 100, height: 100)
        
        if self.userPhotoImageView.image == nil {

            self.userPhotoImageView.image = UIImage(named: "UserProfileDefaultPicture")

        }
        
        self.userPhotoImageView.contentMode = .scaleAspectFill
        
        self.userPhotoImageView.layer.cornerRadius = self.userPhotoImageView.width / 4
        
        self.userPhotoImageView.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(choosePhotoOrCamera))
        
        self.userPhotoImageView.addGestureRecognizer(tap)
        
        self.userPhotoImageView.isUserInteractionEnabled = true
        
        subview.addSubview(self.userPhotoImageView)
        
        alert.customSubview = subview
        
        alert.addButton(" BACK ",
                        backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6),
                        textColor: UIColor.white,
                        showDurationStatus: true) {
                            
                            alert.dismiss(animated: true, completion: nil)
                            
        }
        
        alert.showInfo("Profile Picture", subTitle: "")
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
        
        alert.addButton("Sure",
                        backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6),
                        textColor: UIColor.white, showDurationStatus: false) {
            
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
        
        alert.addButton("Cancel",
                        backgroundColor: UIColor.asiSeaBlue.withAlphaComponent(0.6),
                        textColor: UIColor.white,
                        showDurationStatus: false) {
            
            alert.dismiss(animated: true, completion: nil)
            
        }
        
        alert.showNotice("Logout", subTitle: "Are you sure?", circleIconImage: alertViewIcon)

    }

    func changTableViewAndMap() {
        
        if storeImagePagerView.isHidden {
            
            storeImagePagerView.isHidden = false
            storeImagePagerView.reloadData()
            mapView.isHidden = true
            
        } else {
            
            mapView.isHidden = false
            storeImagePagerView.isHidden = true
            self.storeImagePagerView.isHidden = true
            
        }
    }

}
