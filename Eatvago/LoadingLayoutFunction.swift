//
//  LoadingLayoutFunction.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/15.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Foundation

extension LoadingMatchViewController {
    
    func setLayout() {
        
        if myGender == "man" {
            
            myImageView.image = myPhotoImage
            myImageView.contentMode = .scaleAspectFill
            myImageView.layer.borderColor = UIColor.asiSeaBlue.cgColor
            myImageView.layer.borderWidth = 1.0
            myImageView.layer.cornerRadius =  myImageView.frame.width / 2
            myImageView.clipsToBounds = true
            
            let photoShadow = CALayer()
            photoShadow.shadowOffset = CGSize(width: 0, height: 1)
            photoShadow.shadowColor = UIColor.asiCoolGreyTwo.cgColor
            photoShadow.shadowRadius = 4
            photoShadow.shadowOpacity = 0.8
            myImageView.layer.insertSublayer(photoShadow, at: 0)
            
            myNameLabel.text = myName
            myTextView.text = myGeetingText
            
        } else {
            
            myImageView.image = myPhotoImage
            myImageView.contentMode = .scaleAspectFill
            myImageView.layer.borderColor = UIColor.asiPale.cgColor
            myImageView.layer.borderWidth = 1.0
            myImageView.layer.cornerRadius =  myImageView.frame.width / 2
            myImageView.clipsToBounds = true
            
            let photoShadow = CALayer()
            photoShadow.shadowOffset = CGSize(width: 0, height: 1)
            photoShadow.shadowColor = UIColor.asiCoolGreyTwo.cgColor
            photoShadow.shadowRadius = 4
            photoShadow.shadowOpacity = 0.8
            myImageView.layer.insertSublayer(photoShadow, at: 0)
            
            myNameLabel.text = myName
            myTextView.text = myGeetingText
            
        }
        
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
        self.navigationItem.title = "Matching"
        let titleShadow = NSShadow()
        titleShadow.shadowOffset = CGSize(width: 0, height: 1)
        titleShadow.shadowColor = UIColor.asiBlack50
        titleShadow.shadowBlurRadius = 2
        var size = UIFont.boldSystemFont(ofSize: 25).pointSize
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Chalkboard SE", size: size)!, NSShadowAttributeName: titleShadow]
        // 設定Bar shadow
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.asiTealish85.cgColor
        self.navigationController?.navigationBar.layer.shadowRadius = 4
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.3
        
        // background
        self.backgroundImageView.image = UIImage(named: "matching")
        self.backgroundImageView.alpha = 0.3
//        self.backgroundView.backgroundColor = UIColor.
        
        
        //取消bar button
        self.navigationItem.hidesBackButton = true
        
        self.myTextView.isUserInteractionEnabled = false
        self.oppositePeopleInfoTextView.isUserInteractionEnabled = false
        
    }
    
    
    func setupBackgroundLayer() {
        
        //background
        
//        let viewHalfWidth = self.backgroundView.frame.width / 2
//        
//        let viewHalfHeight = self.backgroundView.frame.height / 2
//        
//        let backgroundGradientColors = [UIColor.asiDarkishBlue.withAlphaComponent(0.4).cgColor,
//                                        UIColor.asiSeaBlue.withAlphaComponent(0.1).cgColor]
//        
//        self.backgroundView.layer.insertSublayer(UIView().generateGradientLayer(gradientcolors: backgroundGradientColors,
//                                                                                gradientframe: CGRect(x: 0, y: 0, width: viewHalfWidth, height: viewHalfHeight),
//                                                                                gradientstartPoint: CGPoint(x: 0, y: 0),
//                                                                                gradientendPoint: CGPoint(x: 1, y: 1)), at: 0)
//        
//        self.backgroundView.layer.insertSublayer(UIView().generateGradientLayer(gradientcolors: backgroundGradientColors,
//                                                                                gradientframe: CGRect(x: viewHalfWidth, y: 0, width: viewHalfWidth, height: viewHalfHeight),
//                                                                                gradientstartPoint: CGPoint(x: 1, y: 0),
//                                                                                gradientendPoint: CGPoint(x: 0, y: 1)), at: 0)
//        
//        self.backgroundView.layer.insertSublayer(UIView().generateGradientLayer(gradientcolors: backgroundGradientColors,
//                                                                                gradientframe: CGRect(x: 0, y: viewHalfHeight, width: viewHalfWidth, height: viewHalfHeight),
//                                                                                gradientstartPoint: CGPoint(x: 0, y: 1),
//                                                                                gradientendPoint: CGPoint(x: 1, y: 0)), at: 0)
//        
//        self.backgroundView.layer.insertSublayer(UIView().generateGradientLayer(gradientcolors: backgroundGradientColors,
//                                                                                gradientframe: CGRect(x: viewHalfWidth, y: viewHalfHeight, width: viewHalfWidth, height: viewHalfHeight),
//                                                                                gradientstartPoint: CGPoint(x: 1, y: 1),
//                                                                                gradientendPoint: CGPoint(x: 0, y: 0)), at: 0)
//        
//        
//        self.backgroundView.layer.masksToBounds = true
        
        
    }
    
}
