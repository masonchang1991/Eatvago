//
//  RandomGamePickerViewDelegate.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/17.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit

extension RandomGameViewController: UIPickerViewDelegate, UIPickerViewDataSource  {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
            
        case distancePickerView: return distancePickOptions.count
            
        case randomCountPickerView: return randomCountPickOptions.count
            
        case addListPickerView:
            
            var totalLocationCount = 0
            
            if let addLocationCount = tabBarVC?.addLocations.count {
                
                totalLocationCount = addLocationCount + searchedLocations.count
                
            }
            
            return totalLocationCount
            
        default: return 0
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
            
        case distancePickerView: return "\(distancePickOptions[row])"
            
        case randomCountPickerView: return "\(randomCountPickOptions[row])"
            
        case addListPickerView:
            
            if let addLocationCount = tabBarVC?.addLocations.count {
                
                print(row, "rowwwwwww")
                print(addLocationCount, "adddddddd")
                
                if row < addLocationCount && addLocationCount != 0 {
                    
                    return tabBarVC?.addLocations[row].name
                    
                } else {
                    
                    return searchedLocations[row - addLocationCount].name
                    
                }
                
            }
            
            return ""
            
        default: return ""
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
            
        case distancePickerView: distanceTextField.text = "\(distancePickOptions[row])"
            
        case randomCountPickerView: randomCountTextField.text = "\(randomCountPickOptions[row])"
            
        default: break 
            
        }
        
    }

    
    
    
    
    
    
    
    
    
}
