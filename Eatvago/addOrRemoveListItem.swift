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

        matchSuccessRoomRef.child("list").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let locations = snapshot.value as? [String: [String: String]] else {
                
                //  若上面無資料則新增資料
                let location = ["storeName": choosedLocation.storeName,
                                "locationLat": choosedLocation.locationLat,
                                "locationLon": choosedLocation.locationLon]
                
                matchSuccessRoomRef.child("list").childByAutoId().updateChildValues(location)
                
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
                
                self.delegate?.manager(self, successAdded: true)
                
            } else {
                
                
               self.removeItemFromFirebase(matchSuccessRoomRef: matchSuccessRoomRef, choosedLocation: choosedLocation, completion: {
                
                //dosomething
                
                self.delegate?.manager(self, successAdded: false)
                
               })
                
            }
    })

}


    func removeItemFromFirebase(matchSuccessRoomRef: DatabaseReference, choosedLocation: ChoosedLocation, completion: @escaping (() -> Void)) {
        
        matchSuccessRoomRef.child("list").queryOrdered(byChild: "storeName").queryEqual(toValue: choosedLocation.storeName).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            print(snapshot.value, "value~~~~~~~~~~")
            print(snapshot.children, "childern~~~~~~~")
            
            for item in snapshot.children{
            
            guard let valueSnap = item as? DataSnapshot else{
            
                return
            
            }
                
                print(valueSnap.key,"-------")
                
                matchSuccessRoomRef.child("list").child(valueSnap.key).removeValue()
                
            }

        })
            
        }
        
        
        
        
        
    }
    
        





