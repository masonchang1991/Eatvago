//
//  AppDelegate.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/7/25.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleMaps
import GooglePlaces
import IQKeyboardManager
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        
        GMSServices.provideAPIKey(googleMapAPIKey[0])
        
        GMSPlacesClient.provideAPIKey(googleMapAPIKey[0])
        
        IQKeyboardManager.shared().isEnabled = true
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        Fabric.with([Crashlytics.self])

        return true
       
    }


}
