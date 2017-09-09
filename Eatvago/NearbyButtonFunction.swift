//
//  NearbyButtonFunction.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/25.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit

extension NearbyViewController {
    
    @IBAction func goToNavigation(_ sender: Any) {
        
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?saddr=\(self.currentLocation.coordinate.latitude),\(self.currentLocation.coordinate.longitude)&daddr=\(self.choosedLocation.latitude),\(self.choosedLocation.longitude)&directionsmode=walking")!)
        } else {
            
            // MARK: Alert user
            
            print("Can't use comgooglemaps://")
            
        }
        
    }
    
    func addToList(_ sender: UIButton) {
        
        if sender.tintColor != UIColor.red {
            
            sender.tintColor = UIColor.red
            
            tabBarC?.addLocations.append(choosedLocation)
            
        } else {
            
            sender.tintColor = UIColor(red: 255.0/255.0, green: 235.0/255.0, blue: 245.0/255.0, alpha: 1.0)
            
            var nowAt = 0
            
            for location in (tabBarC?.addLocations) ?? [] {
                
                if location.name == choosedLocation.name {
                    
                    tabBarC?.addLocations.remove(at: nowAt)
                    
                }
                
                nowAt += 1
            
            }
        }
    }
            
}
