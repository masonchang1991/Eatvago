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
        
        return outputImage ?? UIImage()
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
        
        searchController?.searchBar.barStyle = .default
        
        let searchBarColor = UIColor(red: 255.0/255.0,
                                     green: 230.0/255.0,
                                     blue: 230.0/255.0,
                                     alpha: 0.8)
        
        searchController?.searchBar.barTintColor = searchBarColor
        
        searchBarView.isHidden = true
        
        searchBarHeightConstraint.constant = 0
       
        // background
        
        self.mainBackgroundView.backgroundColor = UIColor(red: 220/255.0,
                                                          green: 255/255.0,
                                                          blue: 255/255.0,
                                                          alpha: 0.4)
        
        //pagerView
        self.listPagerView.backgroundColor = UIColor(red: 200/255.0,
                                                     green: 255/255.0,
                                                     blue: 255/255.0,
                                                     alpha: 0.3)
        
        self.listPagerView.layer.cornerRadius = 8
        
        self.listPagerView.clipsToBounds = true
        
        self.underPagerViewBackgroundView.backgroundColor = UIColor.white
        
        //listPicker
        self.listPickerHeightConstraint.constant = 0
        
        self.listPickerView.isHidden = true
        
        self.navigationButtonForList.isHidden = true

        //tableview
        self.matchRoomTableView.backgroundColor = UIColor(red: 220/255.0,
                                                          green: 255/255.0,
                                                          blue: 255/255.0,
                                                          alpha: 0.4)
        
        self.chatBoxView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        self.chatBoxView.layer.shadowRadius = 1
        
        self.chatBoxView.layer.shadowOpacity = 0.8
        
        self.chatBoxView.layer.shadowColor = UIColor.asiDarkishBlue.cgColor
        
        self.sendMessageButton.layer.shadowColor = UIColor.asiSlate.cgColor
        
        self.sendMessageButton.layer.shadowOpacity = 0.6
        
        self.sendMessageButton.layer.shadowRadius = 2
        
        self.sendMessageButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        
    }
    
    func setLayer() {
        
        // title
        let titleTopColor = UIColor(
            red: 60.0/255.0,
            green: 150.0/255.0,
            blue: 210.0/255.0,
            alpha: 0.8
        )
        
        let titleBottomColor = UIColor(
            red: 115.0/255.0,
            green: 115.0/255.0,
            blue: 255.0/255.0,
            alpha: 0.8
        )

        let titleGradientColors = [titleTopColor.cgColor,
                                   titleBottomColor.cgColor]
        
        self.titleBackgroundView.layer.insertSublayer(UIView().generateGradientLayer(gradientcolors: titleGradientColors,
                                                                                     gradientframe: self.titleBackgroundView.frame,
                                                                                     gradientstartPoint: CGPoint(x: 0.5, y: 0),
                                                                                     gradientendPoint: CGPoint(x: 0.5, y: 1.0)), at: 0)
        //function bar
        
        let functionBarTopColor = UIColor(
            red: 60.0/255.0,
            green: 150.0/255.0,
            blue: 210.0/255.0,
            alpha: 0.6
        )
        
        let functionBarBottomColor = UIColor(
            red: 150.0/255.0,
            green: 150.0/255.0,
            blue: 255.0/255.0,
            alpha: 0.4
        )
        
        let functionBarGradientColors = [functionBarTopColor.cgColor,
                                         functionBarBottomColor.cgColor]
        
        self.functionBarBackgroundView.layer.insertSublayer(UIView().generateGradientLayer(gradientcolors: functionBarGradientColors,
                                                                                           gradientframe: CGRect(x: 0, y: 0, width: functionBarBackgroundView.frame.width, height: functionBarBackgroundView.frame.height),
                                                                                           gradientstartPoint: CGPoint(x: 0.5, y: 0), gradientendPoint: CGPoint(x: 0.5, y: 1.0)), at: 0)
        
        self.functionBarBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        self.functionBarBackgroundView.layer.shadowRadius = 4
        
        self.functionBarBackgroundView.layer.shadowOpacity = 0.8
        
        self.functionBarBackgroundView.layer.shadowColor = UIColor.asiBlack50.cgColor
        
        self.functionBarBackgroundView.layer.masksToBounds = false
        
    }
    
}
