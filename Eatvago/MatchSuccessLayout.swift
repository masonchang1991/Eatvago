//
//  MatchSuccessLayout.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/15.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit


extension UIView {
    
    func generateGradientImage(gradientColors: [CGColor], gradientFrame: CGRect, gradientStartPoint: CGPoint, gradientEndPoint: CGPoint) -> UIImage {
        let gradient = CAGradientLayer()
        let gradientFrame = frame
        gradient.frame = gradientFrame
        gradient.colors = gradientColors
        gradient.startPoint = gradientStartPoint
        gradient.endPoint = gradientEndPoint
        
        UIGraphicsBeginImageContext(gradient.frame.size)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
    func generateGradientLayer(gradientcolors: [CGColor], gradientframe: CGRect, gradientstartPoint: CGPoint, gradientendPoint: CGPoint) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        let frame = gradientframe
        gradient.frame = frame
        gradient.colors = gradientcolors
        gradient.startPoint = gradientstartPoint
        gradient.endPoint = gradientendPoint
        
        return gradient
    }
    
}


extension MatchSuccessViewController {
    
    
    
    func layoutSet() {
        
        // search bar layout
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchBarView.addSubview((searchController?.searchBar)!)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.barStyle = .blackTranslucent
        self.searchBarView.backgroundColor = UIColor.clear
        searchBarView.isHidden = true
        searchBarHeightConstraint.constant = 0
        
        //layout
        self.listPagerView.backgroundColor = UIColor.clear
        self.mainBackgroundView.backgroundColor = UIColor.clear
        
        // title
        let titleGradientColors = [UIColor.asiDarkishBlue.withAlphaComponent(0.8).cgColor,
                                   UIColor.asiSeaBlue.withAlphaComponent(0.8).cgColor]
        
        self.titleBackgroundView.layer.insertSublayer(UIView().generateGradientLayer(gradientcolors: titleGradientColors,
                                                                                     gradientframe: self.titleBackgroundView.frame,
                                                                                     gradientstartPoint: CGPoint(x: 0.5, y: 0),
                                                                                     gradientendPoint: CGPoint(x: 0.5, y: 1.0)), at: 0)
        
        
        //pagerView
        self.listPagerView.backgroundColor = UIColor.asiSeaBlue.withAlphaComponent(0.2)
        self.listPagerView.layer.cornerRadius = 8
        self.listPagerView.clipsToBounds = true
        self.underPagerViewBackgroundView.backgroundColor = UIColor.white
        
        
        //function bar
        let functionBarGradientColors = [UIColor.asiDenimBlue.withAlphaComponent(0.8).cgColor,
                                         UIColor.asiTealish85.withAlphaComponent(0.8).cgColor]
        
        
        
        self.functionBarBackgroundView.layer.insertSublayer(UIView().generateGradientLayer(gradientcolors: functionBarGradientColors,
                                                                                           gradientframe: CGRect(x: 0, y: 0, width: functionBarBackgroundView.frame.width, height: functionBarBackgroundView.frame.height),
                                                                                           gradientstartPoint: CGPoint(x: 0.5, y: 0), gradientendPoint: CGPoint(x: 0.5, y: 1.0)), at: 0)
        
        self.functionBarBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.functionBarBackgroundView.layer.shadowRadius = 4
        self.functionBarBackgroundView.layer.shadowOpacity = 0.8
        self.functionBarBackgroundView.layer.shadowColor = UIColor.asiBlack50.cgColor
        self.functionBarBackgroundView.layer.masksToBounds = false
        
        
        //listPicker
        self.listPickerHeightConstraint.constant = 0
        self.listPickerView.isHidden = true
        self.navigationButtonForList.isHidden = true

        //tableview
        self.matchRoomTableView.backgroundColor = UIColor(red: 156.0/255.0, green: 232.0/255.0, blue: 255.0/255.0, alpha: 1.0).withAlphaComponent(0.4)
        
        //sendmessage box
        
        let chatBoxGradientColors = [UIColor.asiDarkSalmon.withAlphaComponent(0.8).cgColor,
                                   UIColor.asiBrownish.withAlphaComponent(0.8).cgColor]
        
        
        self.chatBoxView.layer.insertSublayer(UIView().generateGradientLayer(gradientcolors: chatBoxGradientColors,
                                                                             gradientframe: self.chatBoxView.frame,
                                                                             gradientstartPoint: CGPoint(x: 0, y: 0),
                                                                             gradientendPoint: CGPoint(x: 1, y: 1)), at: 0)
        
        self.chatBoxView.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.chatBoxView.layer.shadowRadius = 2
        self.chatBoxView.layer.shadowOpacity = 0.8
        self.chatBoxView.layer.shadowColor = UIColor.asiDarkishBlue.cgColor
        
        self.sendMessageButton.layer.shadowColor = UIColor.asiSlate.cgColor
        self.sendMessageButton.layer.shadowOpacity = 0.6
        self.sendMessageButton.layer.shadowRadius = 2
        self.sendMessageButton.layer.shadowOffset = CGSize(width: 0, height: 1)
    
        
        
    }
    
    
    
    
    
    
    
    
    
    
}


