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
//~~~~~
var googleMapAPIKey = ["AIzaSyBaIkDy07ub4iYPhc852JyWeikGgCv8F-0", "AIzaSyBivGI2MbdVzOeeGBvZqqhPO0JQ9BdL87g", "AIzaSyC-vTtOFq2MRx29_Dp-UuPlbjc3tA9NA0I", "AIzaSyCgdyuXgEpb2omTocjALBgHi7wsP3OxmX8", "AIzaSyCNvYlOUnIJ7rZ6ikyw2l8z6GIYJgKCGb4", "AIzaSyAzzNQSinBXS1OGKEbSYbmcUQyds1Ep6EE"]

var googleMapDistanceMatrixAPIKey = "AIzaSyAff1FGPRjJM99yVPKacpnbGPjmW_-n820"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GMSServices.provideAPIKey(googleMapAPIKey[0])
        GMSPlacesClient.provideAPIKey(googleMapAPIKey[0])
        
        IQKeyboardManager.shared().isEnabled = true
//        IQKeyboardManager.shared().isEnableAutoToolbar = false
        UIApplication.shared.statusBarStyle = .lightContent
        Fabric.with([Crashlytics.self])

        return true
       
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
