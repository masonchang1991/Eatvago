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


class RandomGameViewController: UIViewController, MagneticDelegate {

  
    @IBOutlet weak var randomGameView: UIView!
    
    var tabBarVC: MainTabBarController?
    
    //swiftlint:disable force_cast
    var skView: SKView {
        return view as! SKView
    }
    //swiftlint:enable force_cast
    
    var randomRestaurant = [Location]()
    
    var magneticDelegate: MagneticDelegate? // magnetic delegate
    var allowsMultipleSelection: Bool = true// controls whether you can select multiple nodes. defaults to true
    var selectedChildren: [Node] = [] // returns selected chidren
    
    
    
    override func loadView() {
        super.loadView()
        
        self.view = SKView(frame: self.view.bounds)
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tbC = self.tabBarController as? MainTabBarController ?? MainTabBarController()
        randomRestaurant = tbC.fetchedLocations
        
        print(randomRestaurant)
        
        //建立泡泡視窗
        let magnetic = Magnetic(size: self.view.bounds.size)
        skView.presentScene(magnetic)
        let node = Node(text: "Italy", image: UIImage(named: "italy"), color: .red, radius: 30)
        magnetic.addChild(node)
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    // add node
//    func addNode() {
//        let node = Node(text: "Italy", image: UIImage(named: "italy"), color: .red, radius: 30)
//        //magnetic
//    }
//    
//    // remove node
//    func removeNode() {
//        node.removeFromParent()
//    }
    
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        // handle node selection
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        // handle node deselection
    }

}
