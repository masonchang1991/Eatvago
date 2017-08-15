//
//  MainTabBarController.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/6.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    var fetchedLocations = [Location]()
    
    var addLocations = [Location]()
    
    var filterDistance = ""
    
    var keywordText = ""
    
    var nearbyViewController: UIViewController?
    
    var userPhoto: UIImageView = UIImageView()
    
    var userPhotoURLString: String = ""

}
