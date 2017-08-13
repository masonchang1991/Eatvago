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
        
        
        self.addListPickerView.backgroundColor = UIColor.clear
        
        self.setRandomView.backgroundColor = UIColor.clear
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchView.addSubview((searchController?.searchBar)!)
        view.addSubview(searchView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.barStyle = .blackTranslucent
        
        // outlet fave button bug need to set two times color
        searchButton.isSelected = false
        openSetRandomButton.isSelected = false
        searchButton.normalColor = UIColor.asiSeaBlue
        openSetRandomButton.normalColor = UIColor.asiSeaBlue
        navigationButton.imageView?.contentMode = .scaleAspectFit
        navigationButton.isSelected = false
        navigationButton.normalColor = UIColor.asiSeaBlue
        
        self.searchView.backgroundColor = UIColor.clear
        
        self.randomGameMagneticView.backgroundColor = UIColor.clear
        self.randomGameMagneticView.magnetic.backgroundColor = UIColor.clear
        randomGameMagneticView.layer.backgroundColor = UIColor.clear.cgColor
        
        self.view.backgroundColor = UIColor.white
        
        
        
        
    }
    
    
}
