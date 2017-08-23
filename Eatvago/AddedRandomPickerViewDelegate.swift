//
//  AddedRandomPickerViewDelegate.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/21.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit

extension AddedRandomViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

//            var totalLocationCount = 0
//        
//        if ifAddFavoriteList == true {
//        
//        
//            if let addLocationCount = tabBarVC?.addLocations.count {
//                
//                totalLocationCount = addLocationCount + searchedLocations.count
//                
//            }
//            
//            
//        } else {
//            
//            totalLocationCount = searchedLocations.count
//            
//        }
//        
//            return totalLocatiovarunt
        
        return self.maxElements
  
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var singlePickerLabel: UILabel
        if let view = view as? UILabel {
            singlePickerLabel = view
        } else {
            singlePickerLabel = UILabel()
        }
        
        singlePickerLabel.textColor = UIColor.white
        singlePickerLabel.textAlignment = .center
        singlePickerLabel.font = UIFont(name: "Chalkboard SE", size: 20) // or UIFont.boldSystemFont(ofSize: 20)
        singlePickerLabel.adjustsFontSizeToFitWidth = true
        singlePickerLabel.minimumScaleFactor = 0.5
        
        
        self.currentRow = row
        
        if ifAddFavoriteList == true {
            
            if (tabBarVC?.addLocations.count)! + searchedLocations.count == 0 {
                return UILabel()
            }
            
            
            if let addLocationCount = tabBarVC?.addLocations.count {
                
                maxRows = addLocationCount + searchedLocations.count
                
                let myRow = row % maxRows
                
                if myRow < addLocationCount && addLocationCount != 0 {
                    
                    singlePickerLabel.backgroundColor = colorArray[myRow % colorArray.count]
                    
                    singlePickerLabel.text = tabBarVC?.addLocations[myRow].name
                    
                    return singlePickerLabel
                    
                } else {
                    
                    singlePickerLabel.backgroundColor = colorArray[(myRow - addLocationCount) % colorArray.count]
                    
                    singlePickerLabel.text = searchedLocations[myRow - addLocationCount].name
                    
                    return singlePickerLabel
                    
                }
                
            }
            
        } else {
            
            if searchedLocations.count == 0 {
                return UILabel()
            }
            
            maxRows = searchedLocations.count
            
            let myRow = row % maxRows
            
            singlePickerLabel.backgroundColor = colorArray[myRow % colorArray.count]
            
            singlePickerLabel.text = searchedLocations[myRow].name
            
            return singlePickerLabel
            
        }
        
        return UILabel()

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}