//
//  MatchSuccessPickerViewDelegate.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/13.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//


import UIKit


extension MatchSuccessViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.choosedLocations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var listLocation = [String]()
        for (_, value) in self.choosedLocations {
            
            listLocation.append(value.storeName)
            
        }
        
      return listLocation[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        
    }
    
}
