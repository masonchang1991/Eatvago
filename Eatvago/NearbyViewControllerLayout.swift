//
//  NearbyViewControllerLayout.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/16.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit

extension NearbyViewController {
    
    func setupLayout() {
        
        // hear button
        self.addToListButton.tintColor = UIColor.white.withAlphaComponent(0.7)
        
        // 設定Bar漸層 ＆ call func
        let gradient = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.width
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 64)
        gradient.frame = defaultNavigationBarFrame
        let barTopColor = UIColor(red: 60.0/255.0, green: 150.0/255.0, blue: 210.0/255.0, alpha: 0.8)
        let barBottomColor = UIColor(red: 115.0/255.0, green: 115.0/255.0, blue: 255.0/255.0, alpha: 0.8)
        
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
        
        //userinfo textview
        self.userInfoTextView.layer.cornerRadius = 10
        self.userInfoTextView.clipsToBounds = true
        self.userInfoTextView.backgroundColor = UIColor.clear
        
        //userinfo background view
        
        // user photo
        
        self.userPhotoImageView.contentMode = .scaleAspectFill
        self.userPhotoImageView.layer.cornerRadius = self.userPhotoImageView.frame.width / 2
        self.userPhotoImageView.clipsToBounds = true
        
        //background image

        self.backgroundImageView.alpha = 0
        
        // logout button
        self.logoutButton.tintColor = UIColor.white
        
        //changeToMapbutton
        
    }
    
    func setupLayer() {
        
        //function bar 1
        let functionBarGradientColors = [UIColor.asiTealish85.withAlphaComponent(0.4).cgColor,
                                        UIColor.asiSeaBlue.withAlphaComponent(0.1).cgColor]
        
        self.functionBarView.layer.insertSublayer(UIView().generateGradientLayer(gradientcolors: functionBarGradientColors,
                                                                                 gradientframe: self.functionBarView.bounds, gradientstartPoint: CGPoint(x: 0, y: 0), gradientendPoint: CGPoint(x: 1, y: 1.0)), at: 0)
        
        self.functionBarView.layer.shadowOffset = CGSize(width: 0.2, height: 0.8)
        self.functionBarView.layer.shadowColor = UIColor.asiBlack50.cgColor
        self.functionBarView.layer.shadowRadius = 1
        self.functionBarView.layer.shadowOpacity = 0.4
        
        // userinfo background
        self.userInfoBackgroundView.layer.shadowOffset = CGSize(width: 0.2, height: 0.8)
        self.userInfoBackgroundView.layer.shadowColor = UIColor.asiDenimBlue.withAlphaComponent(0.8).cgColor
        self.userInfoBackgroundView.layer.shadowOpacity = 0.7
        self.userInfoBackgroundView.layer.shadowRadius = 1
        self.userInfoBackgroundView.backgroundColor = UIColor.asiTealish85.withAlphaComponent(0.2)
        self.userInfoBackgroundView.clipsToBounds = false

        let purpleColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        
        let userInfoBackgroundGradientColors = [UIColor.white.withAlphaComponent(0.1).cgColor,
                                                purpleColor.withAlphaComponent(0.6).cgColor]
        
        self.userInfoBackgroundView.layer.insertSublayer(UIView().generateGradientLayer(gradientcolors: userInfoBackgroundGradientColors,
                                                                                     gradientframe: self.userInfoBackgroundView.bounds,
                                                                                     gradientstartPoint: CGPoint(x: 0, y: 0),
                                                                                     gradientendPoint: CGPoint(x: 1.0, y: 1.0)), at: 0)
        // userinfo textview background
        
        self.userInfoTextBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.userInfoTextBackgroundView.layer.shadowColor = UIColor.asiDenimBlue.withAlphaComponent(0.8).cgColor
        self.userInfoTextBackgroundView.layer.shadowOpacity = 0.7
        self.userInfoTextBackgroundView.layer.shadowRadius = 1
        self.userInfoTextBackgroundView.backgroundColor = UIColor.asiTealish85.withAlphaComponent(0.2)
        self.userInfoTextBackgroundView.clipsToBounds = false
        self.userInfoTextBackgroundView.layer.masksToBounds = true

        let lightWhiteBlue = UIColor(red: 225.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        let userInfoTextBackgroundGradientColors = [UIColor.white.withAlphaComponent(0.5).cgColor,
                                               lightWhiteBlue.withAlphaComponent(0.5).cgColor]
        
        self.userInfoTextBackgroundView.layer.insertSublayer(UIView().generateGradientLayer(gradientcolors: userInfoTextBackgroundGradientColors,
                                                                                        gradientframe: self.userInfoTextBackgroundView.bounds,
                                                                                        gradientstartPoint: CGPoint(x: 0.5, y: 0),
                                                                                        gradientendPoint: CGPoint(x: 0.5, y: 1.0)), at: 0)
        
        //bottom function bar
        let bottomFunctionBarGradientColors = [UIColor.asiTealish85.withAlphaComponent(0.4).cgColor,
                                         UIColor.asiSeaBlue.withAlphaComponent(0.1).cgColor]
        
        self.bottomFunctionBarView.layer.insertSublayer(UIView().generateGradientLayer(gradientcolors: bottomFunctionBarGradientColors,
                                                                                 gradientframe: self.bottomFunctionBarView.bounds, gradientstartPoint: CGPoint(x: 0, y: 1), gradientendPoint: CGPoint(x: 1, y: 0)), at: 0)
        
        self.bottomFunctionBarView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.bottomFunctionBarView.layer.shadowColor = UIColor.asiBlack50.cgColor
        self.bottomFunctionBarView.layer.shadowRadius = 2
        self.bottomFunctionBarView.layer.shadowOpacity = 0.4

    }
    
}
