//
//  NearbyViewControllerLayout.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/16.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import ExpandingMenu

extension NearbyViewController {
    
    func setupLayout() {
        
        // hear button
        self.addToListButton.tintColor = UIColor(red: 255.0/255.0, green: 235.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        
        // 設定Bar漸層 ＆ call func
        let gradient = CAGradientLayer()
        
        let sizeLength = UIScreen.main.bounds.size.width
        
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 64)
        
        gradient.frame = defaultNavigationBarFrame
        
        let barTopColor = UIColor(
            red: 60.0/255.0,
            green: 150.0/255.0,
            blue: 210.0/255.0,
            alpha: 0.8
        )
        
        let barBottomColor = UIColor(
            red: 115.0/255.0,
            green: 115.0/255.0,
            blue: 255.0/255.0,
            alpha: 0.8
        )
        
        gradient.colors = [barTopColor.cgColor,
                           barBottomColor.cgColor]
        
        gradient.startPoint = CGPoint(x: 0, y: 0.0)
        
        gradient.endPoint = CGPoint(x: 1.0, y: 1.2)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIView().image(fromLayer: gradient), for: .default)
        
        self.navigationController?.navigationBar.layer.masksToBounds = false
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        // 設定Bar Title
        self.navigationItem.title = "Nearby Restaurant"
        
        let titleShadow = NSShadow()
        
        titleShadow.shadowOffset = CGSize(width: 0, height: 1)
        
        titleShadow.shadowColor = UIColor.asiBlack50
        
        titleShadow.shadowBlurRadius = 2
        
        var size = UIFont.boldSystemFont(ofSize: 25).pointSize
        
        if UIScreen.main.bounds.width < 340 {
            
            size = UIFont.boldSystemFont(ofSize: 20).pointSize
            
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Chalkboard SE", size: size)!, NSShadowAttributeName: titleShadow]
        
        //設定一開始的限制條件
        settingTitleLabel.text = " Searching By : "
        settingLabel.text = " Radius: \(filterDistance) M\n Keyword: None "
        settingLabel.textAlignment = .center
        
        //base background pagerview底下的
        self.baseBackgroundView.backgroundColor = UIColor(
            red: 230.0/255.0,
            green: 220.0/255.0,
            blue: 210.0/255.0,
            alpha: 0.5
        )

        
        // nearbyInfoBackground set
        self.nearByInfoBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        self.nearbyInfoBackgroundImageView.alpha = 0.5
        
        //page control view
        self.firstLeftTwoPagerViewControlView.layer.cornerRadius = self.firstLeftTwoPagerViewControlView.width / 2
        
        self.firstLeftTwoPagerViewControlView.clipsToBounds = true
        
        self.firstLeftTwoPagerViewControlView.backgroundColor = UIColor(
            red: 230.0/255.0,
            green: 255.0/255.0,
            blue: 255.0/255.0,
            alpha: 0.9
        )
        
        self.firstLeftOnePagerViewControlView.layer.cornerRadius = self.firstLeftOnePagerViewControlView.width / 2
        
        self.firstLeftOnePagerViewControlView.clipsToBounds = true
        
        self.firstLeftOnePagerViewControlView.backgroundColor = UIColor(
            red: 230.0/255.0,
            green: 255.0/255.0,
            blue: 255.0/255.0,
            alpha: 0.9
        )
        
        self.firstPagerViewControlView.layer.cornerRadius = self.firstPagerViewControlView.width / 2
        
        self.firstPagerViewControlView.clipsToBounds = true
        
        self.firstPagerViewControlView.backgroundColor = UIColor(
            red: 230.0/255.0,
            green: 255.0/255.0,
            blue: 255.0/255.0,
            alpha: 0.9
        )
        
        self.secondPagerViewControlView.layer.cornerRadius = self.secondPagerViewControlView.width / 2
        
        self.secondPagerViewControlView.clipsToBounds = true
        
        self.secondPagerViewControlView.backgroundColor = UIColor.red
        
        self.thirdPagerViewControlView.layer.cornerRadius = self.thirdPagerViewControlView.width / 2
        
        self.thirdPagerViewControlView.clipsToBounds = true
        
        self.thirdPagerViewControlView.backgroundColor = UIColor(
            red: 230.0/255.0,
            green: 255.0/255.0,
            blue: 255.0/255.0,
            alpha: 0.9
        )
        
        self.thirdRightOnePagerViewControlView.layer.cornerRadius = self.thirdRightOnePagerViewControlView.width / 2
        
        self.thirdRightOnePagerViewControlView.clipsToBounds = true
        
        self.thirdRightOnePagerViewControlView.backgroundColor = UIColor(
            red: 230.0/255.0,
            green: 255.0/255.0,
            blue: 255.0/255.0,
            alpha: 0.9
        )
        
        self.thirdRightTwoPagerViewControlView.layer.cornerRadius = self.thirdRightTwoPagerViewControlView.width / 2
        
        self.thirdRightTwoPagerViewControlView.clipsToBounds = true
        
        self.thirdRightTwoPagerViewControlView.backgroundColor = UIColor(
            red: 230.0/255.0,
            green: 255.0/255.0,
            blue: 255.0/255.0,
            alpha: 0.9
        )
        
    }
    
    func addMenuButton() {
        
        //加入menu button
        let mainMenuButtonSize: CGSize = CGSize(width: 40, height: 40)
        let menuButtonSize: CGSize = CGSize(width: 40, height: 40)
        let mainMenuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: mainMenuButtonSize), centerImage: UIImage(named: "menu")!, centerHighlightedImage: UIImage(named: "menu")!)
        
        mainMenuButton.center = CGPoint(x: 20.0, y: 20.0)
        view.addSubview(mainMenuButton)
        
        let profileButton = ExpandingMenuItem(size: menuButtonSize, title: "Profile", titleColor: UIColor.white, image: UIImage(named: "profile")!, highlightedImage: UIImage(named: "profile")!, backgroundImage: nil, backgroundHighlightedImage: nil) {
            self.setUpProfile()
        }
        
        let mapButton = ExpandingMenuItem(size: menuButtonSize, title: "View In Map", titleColor: UIColor.white, image: UIImage(named: "Map")!, highlightedImage: UIImage(named: "Map")!, backgroundImage: nil, backgroundHighlightedImage: nil) {
            self.changTableViewAndMap()
        }
        
        let setupButton = ExpandingMenuItem(size: menuButtonSize, title: "Search Setting", titleColor: UIColor.white, image: UIImage(named: "Setup")!, highlightedImage: UIImage(named: "Setup")!, backgroundImage: nil, backgroundHighlightedImage: nil) {
            self.setUpFilter()
            
        }
        
        let logoutButton = ExpandingMenuItem(size: menuButtonSize, title: "Log out", titleColor: UIColor.white, image: UIImage(named: "logoutExit")!, highlightedImage: UIImage(named: "logoutExit")!, backgroundImage: nil, backgroundHighlightedImage: nil) {
            self.logout()
        }
        
        mainMenuButton.addMenuItems([profileButton, mapButton, setupButton, logoutButton])
        mainMenuButton.expandingDirection = .bottom
        mainMenuButton.menuTitleDirection = .right

    }

}
