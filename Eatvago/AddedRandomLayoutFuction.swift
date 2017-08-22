//
//  AddedRandomLayoutFuction.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/21.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit

extension AddedRandomViewController {
    
    func setLayout() {
        
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
        self.navigationItem.title = "Favorite List"
        let titleShadow = NSShadow()
        titleShadow.shadowOffset = CGSize(width: 0, height: 1)
        titleShadow.shadowColor = UIColor.asiBlack50
        titleShadow.shadowBlurRadius = 2
        var size = UIFont.boldSystemFont(ofSize: 25).pointSize
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Chalkboard SE", size: size)!, NSShadowAttributeName: titleShadow]
        
        // background
        self.backgroundImageView.contentMode = .scaleAspectFill
        self.backgroundImageView.alpha = 0.1

        
        
    }
    
    
}
