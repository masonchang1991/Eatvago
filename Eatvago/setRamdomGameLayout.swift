//
//  setRamdomGameLayout.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/13.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit

extension RandomGameViewController {
    
    func setLayout() {
        
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
        self.navigationItem.title = "Find by Random!"
        let titleShadow = NSShadow()
        titleShadow.shadowOffset = CGSize(width: 0, height: 1)
        titleShadow.shadowColor = UIColor.asiBlack50
        titleShadow.shadowBlurRadius = 2
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Chalkboard SE", size: UIFont.boldSystemFont(ofSize: 30).pointSize)!, NSShadowAttributeName: titleShadow]

        self.addListPickerView.backgroundColor = UIColor.clear
        
        self.setRandomView.backgroundColor = UIColor.clear
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchView.addSubview((searchController?.searchBar)!)
        view.addSubview(searchView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.searchBar.barStyle = .default
        // outlet fave button bug need to set two times color
        searchButton.isSelected = false
        openSetRandomButton.isSelected = false
        searchButton.normalColor = UIColor.asiSeaBlue
        openSetRandomButton.normalColor = UIColor.asiSeaBlue
        navigationButton.imageView?.contentMode = .scaleAspectFit
        navigationButton.isSelected = false
        navigationButton.normalColor = UIColor.asiWhiteTwo
        navigationButton.tintColor = UIColor.asiWhiteTwo
        
        self.searchView.backgroundColor = UIColor.clear
        
        self.randomGameMagneticView.backgroundColor = UIColor.clear
        self.randomGameMagneticView.magnetic.backgroundColor = UIColor.clear
        randomGameMagneticView.layer.backgroundColor = UIColor.clear.cgColor
        
        // setRandom Background
        let backgroundGradientColors = [UIColor.asiDarkishBlue.withAlphaComponent(0.6).cgColor,
                                        UIColor.asiSeaBlue.withAlphaComponent(0.3).cgColor]
        
        self.setRandomView.backgroundColor = UIColor.clear
        self.setRandomView.layer.insertSublayer(UIView().generateGradientLayer(gradientcolors: backgroundGradientColors,
                                                                               gradientframe: self.setRandomView.frame,
                                                                               gradientstartPoint: CGPoint(x: 0.5, y: 0), gradientendPoint: CGPoint(x: 0.5, y: 1.0)), at: 0)
        
        // background
        self.randomGameBackgorundImageView.contentMode = .scaleAspectFill
        self.randomGameBackgorundImageView.blur(withStyle: .prominent)
        
        //nivagation button
//        self.navigationButton.tintColor = UIColor.asiDenimBlue.withAlphaComponent(0.8)
        
    }
    
}
