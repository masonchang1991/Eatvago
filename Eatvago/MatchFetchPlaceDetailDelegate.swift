//
//  MatchFetchPlaceDetailDelegate.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/12.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import SCLAlertView

extension MatchSuccessViewController: FetchPlaceIdDetailDelegate {
    
    func manager(_ manager: FetchPlaceIdDetailManager, searchBy placeId: String, didGet locationWithDetail: Location, senderTag: Int) {
        
        nearbyLocationDictionary["\(placeId)"] = locationWithDetail
        
        self.locations[senderTag] = locationWithDetail
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 15)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 10)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("OK") {
            
            alert.dismiss(animated: true, completion: nil)
            
        }
        
        let subTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 216, height: 70))
        
        let x = (subTextView.frame.width - 180) / 2
        
        let textView = UITextView(frame: CGRect(x: x, y: 10, width: 180, height: 50))
        
        textView.text = "電話號碼為 \(self.locations[senderTag].formattedPhoneNumber)"
        
        textView.layer.borderColor = UIColor.blue.cgColor
        
        textView.layer.borderWidth = 1.5
        
        textView.layer.cornerRadius = 5
        
        subTextView.addSubview(textView)
        
        alert.customSubview = subTextView
        
        alert.showTitle("\(self.locations[senderTag].name)", subTitle: "", style: .success)
        
    }
    
    func manager(_ manager: FetchPlaceIdDetailManager, didFailWith error: Error) {
        
    }
}
