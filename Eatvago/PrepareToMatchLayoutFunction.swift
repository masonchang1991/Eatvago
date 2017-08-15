//
//  PrepareToMatchLayoutFunction.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/15.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit



extension PrepareToMatchViewController {
    
    
    
    func setUpLayout() {
        
        
        self.userPhotoImageView.image = nearbyViewController?.userPhotoImageView.image
        self.userPhotoImageView.layer.cornerRadius = self.userPhotoImageView.frame.width/2
        self.userPhotoImageView.clipsToBounds = true
        
        self.greetingTextView.layer.cornerRadius = 30
        self.greetingTextView.clipsToBounds = true
        self.greetingTextView.backgroundColor = UIColor.asiDarkSand
        self.greetingTextView.backgroundColor?.withAlphaComponent(0.8)
        
        
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
        self.navigationItem.title = "Match"
        let titleShadow = NSShadow()
        titleShadow.shadowOffset = CGSize(width: 0, height: 1)
        titleShadow.shadowColor = UIColor.asiBlack50
        titleShadow.shadowBlurRadius = 2
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Chalkduster", size: UIFont.boldSystemFont(ofSize: 30).pointSize)!, NSShadowAttributeName: titleShadow]
        // 設定Bar shadow
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.asiTealish85.cgColor
        self.navigationController?.navigationBar.layer.shadowRadius = 4
        self.navigationController?.navigationBar.layer.shadowOpacity = 1

        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
}
