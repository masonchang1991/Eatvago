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
        gradient.colors = [UIColor.asiDarkishBlue.withAlphaComponent(1.0).cgColor,
                           UIColor.asiSeaBlue.withAlphaComponent(0.8).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.navigationController?.navigationBar.setBackgroundImage(UIView().image(fromLayer: gradient), for: .default)
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.isTranslucent = false
        
        // 設定Bar Title
        self.navigationItem.title = "Nearby Restaurant"
        let titleShadow = NSShadow()
        titleShadow.shadowOffset = CGSize(width: 0, height: 1)
        titleShadow.shadowColor = UIColor.asiBlack50
        titleShadow.shadowBlurRadius = 2
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Chalkboard SE", size: UIFont.boldSystemFont(ofSize: 25).pointSize)!, NSShadowAttributeName: titleShadow]

        
        
        // userinfo textview background
        self.userInfoTextBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.userInfoTextBackgroundView.layer.shadowColor = UIColor.asiDenimBlue.withAlphaComponent(0.8).cgColor
        self.userInfoTextBackgroundView.layer.shadowOpacity = 1.0
        self.userInfoTextBackgroundView.layer.shadowRadius = 3
        self.userInfoTextBackgroundView.backgroundColor = UIColor.asiTealish85.withAlphaComponent(0.2)
        self.userInfoTextBackgroundView.clipsToBounds = false
        
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
        
        self.backgroundImageView.blurred(withStyle: .regular)
        self.backgroundImageView.contentMode = .scaleToFill

        
        
        
        
        
    }
    
    
    
    
    
}
