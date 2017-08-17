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
            
        case addListPickerView: return (tabBarVC?.addLocations.count) ?? 0 + searchedLocations.count
            
        default: return 0
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
            
        case distancePickerView: return "\(distancePickOptions[row])"
            
        case randomCountPickerView: return "\(randomCountPickOptions[row])"
            
        case addListPickerView:
            
            if row <= (tabBarVC?.addLocations.count) ?? 0 && (tabBarVC?.addLocations.count) ?? 0 != 0 {
                
                return tabBarVC?.addLocations[row].name
                
            } else {
                
                return searchedLocations[row - ((tabBarVC?.addLocations.count) ?? 0)].name
                
            }
            
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
