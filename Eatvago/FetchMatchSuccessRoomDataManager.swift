//
//  FetchMatchSuccessRoomData.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/12.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

protocol FetchMatchSuccessRoomDataDelegate:class {
    
    func manager(_ manager: FetchMatchSuccessRoomDataManager, didGet successRoomData: MatchSuccessRoom)
    
    func manager(_ manager: FetchMatchSuccessRoomDataManager, didFail withError: String)
    
}


class FetchMatchSuccessRoomDataManager {
    
    
    weak var delegate: FetchMatchSuccessRoomDataDelegate?
    
    
    func fetchRoomData(matchSuccessRoomRef: DatabaseReference) {
        
    
        matchSuccessRoomRef.observe(.value, with: { (snapshot) in
            
            guard let roomData = snapshot.value as? [String: String] else { return }
            
            guard let attenderUID = roomData["attender"],
                let attenderLocationLatString = roomData["attenderLocationLat"],
                let attenderLocationLonString = roomData["attenderLocationLon"],
                let ownerUID = roomData["owner"],
                let ownerLocationLatString = roomData["ownerLocationLat"],
                let ownerLocationLonString = roomData["ownerLocationLon"] else {
                    
                    self.delegate?.manager(self, didFail: "JSON FAIL")
                    return
            }
            
            guard let attenderLocationLat = Double(attenderLocationLatString),
                let attenderLocationLon = Double(attenderLocationLonString),
                let ownerLocationLat = Double(ownerLocationLatString),
                let ownerLocationLon = Double(ownerLocationLonString) else {
                    
                    self.delegate?.manager(self, didFail: "transfrom location string to double fail")
                    return
                    
            }
            
            let pointAttender = CLLocationCoordinate2D(latitude: attenderLocationLat,
                                                       longitude: attenderLocationLon)
            
            let pointOwner = CLLocationCoordinate2D(latitude: ownerLocationLat,
                                                    longitude: ownerLocationLon)
            
            let collectionPiont = [pointAttender, pointOwner]
            
            let centerPoint = middlePointOfListMarkers(listCoords: collectionPiont)
            
            let successRoomData = MatchSuccessRoom(ownerUID: ownerUID, attenderUID: attenderUID, attenderLocation: pointAttender, ownerLocation: pointOwner, centerLocation: centerPoint)
            
            self.delegate?.manager(self, didGet: successRoomData)
            
            
        })
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
