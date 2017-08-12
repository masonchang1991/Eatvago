//
//  MatchSuccessRoomDataStruct.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/12.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import Foundation
import CoreLocation

struct MatchSuccessRoom {
    
    var ownerUID: String
    
    var attenderUID: String
    
    var attenderLocation: CLLocationCoordinate2D

    var ownerLocation: CLLocationCoordinate2D
    
    var centerLocation: CLLocationCoordinate2D
    
    var listRoomId: String
    
    
}


struct ChoosedLocation {
    
    var storeName: String
    
    var locationLat: String
    
    var locationLon: String
    
}
