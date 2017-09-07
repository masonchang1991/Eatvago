//
//  addOrRemoveListItem.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/12.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

protocol addOrRemoveListItemDelegate:class {
    
    func manager(_ manager: AddOrRemoveListItemManager, successAdded: Bool)
    
    func manager(_ manager: AddOrRemoveListItemManager, didFail withError: String)
    
}

class AddOrRemoveListItemManager {

    weak var delegate: addOrRemoveListItemDelegate?
    
    func addOrRemovelistItem(matchSuccessRoomRef: DatabaseReference, choosedLocation: ChoosedLocation) {
        
        var choosedLocations: [String: ChoosedLocation] = [:]

        matchSuccessRoomRef.child("list").observeSingleEvent(of: .value, with: { [weak self](snapshot) in
            
            guard let `weakself` = self else { return }
            
            guard let locations = snapshot.value as? [String: [String: String]] else {
                
                //  若上面無資料則新增資料
                let location = ["storeName": choosedLocation.storeName,
                                "locationLat": choosedLocation.locationLat,
                                "locationLon": choosedLocation.locationLon]
                
                matchSuccessRoomRef.child("list").childByAutoId().updateChildValues(location)
                
                weakself.delegate?.manager(weakself, successAdded: true)
                
                return
            }
            
            for (_, location) in locations {
                
                let storeName = location["storeName"]
                
                let locationLat = location["locationLat"]
                
                let locationLon = location["locationLon"]
                
                choosedLocations[storeName ?? ""] = ChoosedLocation(storeName: storeName ?? "",
                                                                         locationLat: locationLat ?? "",
                                                                         locationLon: locationLon ?? "")
                
            }
            
            if choosedLocations[choosedLocation.storeName] == nil {
                
                let location = ["storeName": choosedLocation.storeName,
                                "locationLat": choosedLocation.locationLat,
                                "locationLon": choosedLocation.locationLon]
                
                matchSuccessRoomRef.child("list").childByAutoId().updateChildValues(location)
                
                weakself.delegate?.manager(weakself, successAdded: true)
                
            } else {
                
               weakself.removeItemFromFirebase(matchSuccessRoomRef: matchSuccessRoomRef, choosedLocation: choosedLocation, completion: { (_) in
                
                //dosomething
                
                weakself.delegate?.manager(weakself, successAdded: false)
                
               })
                
            }
    })

}

    func removeItemFromFirebase(matchSuccessRoomRef: DatabaseReference, choosedLocation: ChoosedLocation, completion: @escaping ((Bool) -> Void)) {
        
        matchSuccessRoomRef.child("list").queryOrdered(byChild: "storeName").queryEqual(toValue: choosedLocation.storeName).observeSingleEvent(of: .value, with: { (snapshot) in
            
            for item in snapshot.children {
                
                guard let valueSnap = item as? DataSnapshot else {
                    
                    self.delegate?.manager(self, didFail: "remove Fail")
                    
                    return
                    
                }
                
                print(valueSnap.key, "-------")
                
                matchSuccessRoomRef.child("list").child(valueSnap.key).removeValue()
                
                completion(true)
                
            }

        })
            
        }
        
    }
