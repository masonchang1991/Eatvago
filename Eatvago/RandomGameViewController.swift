//
//  RandomGameViewController.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/2.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Magnetic
import SpriteKit

class RandomGameViewController: UIViewController, MagneticDelegate, UITabBarControllerDelegate {
  
    
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
    
    var tabBarVC: MainTabBarController?
    

//    
//    var magneticDelegate: MagneticDelegate? // magnetic delegate
//    var allowsMultipleSelection: Bool = true// controls whether you can select multiple nodes. defaults to true
//    var selectedChildren: [Node] = [] // returns selected chidren

    var totalRestaurants = [Location]()
    var randomRestaurants = [Location]()
    
    var nodeDictionary = [String: String]()
    var nodes = [Node]()

    
    var colorArray: [UIColor] =
        [UIColor.red, UIColor.orange, UIColor.green, UIColor.blue, UIColor.purple, UIColor.brown]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        removeAllNode(magnetic: magnetic)
        
        self.randomRestaurants = []
        
        let tbC = self.tabBarController as? MainTabBarController ?? MainTabBarController()
        
        tbC.delegate = self
        
        totalRestaurants = tbC.fetchedLocations
        
        randomGameMagneticView.presentScene(magnetic)
        
        generateRandomRetaurant(randomCounts: 6, totalRestaurants: totalRestaurants)
        
        var randomCount = 0
        
        for restaurant in self.randomRestaurants {
            
            self.nodeDictionary["\(randomCount)"] = restaurant.name
            
            addNode(magnetic: magnetic,
                    text: "\(randomCount)",
                    image: restaurant.photo,
                    color: colorArray[randomCount],
                    radius: 30)
            
            //避免count超過color array長度
            if randomCount == (colorArray.count - 1) {
                
                randomCount = 0
                
            } else {
                
                randomCount += 1
                
            }

        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        self.navigationController?.popViewController(animated: true)
    }
    
    

    func generateRandomRetaurant(randomCounts: Int, totalRestaurants: [Location]) {
        
        let upperBound = totalRestaurants.count - 1
        
        var randomRestaurantsCount = 0
        
        var randomRestaurants: [String: String] = [:]
        
        while randomRestaurantsCount != randomCounts {
            
            let randomNumner = Int(arc4random_uniform(UInt32(upperBound - 1)))
            
            if randomRestaurants[totalRestaurants[randomNumner].name] == nil {
                
                self.randomRestaurants.append(totalRestaurants[randomNumner])
                
                randomRestaurants["\(totalRestaurants[randomNumner].name)"] = totalRestaurants[randomNumner].name
                
                randomRestaurantsCount += 1
                
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
        
        guard let key = node.text else {
            return
        }
        
        node.text = nodeDictionary[key]
        
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        // handle node deselection
    }

}
