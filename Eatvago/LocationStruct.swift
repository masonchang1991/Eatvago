//
//  LocationStruct.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/7/28.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import Foundation

struct Location {
    var latitude: Double
    var longitude: Double
    var name: String
    var id: String
    var openingHours: [String: Any]?
    var placeId: String
    var types: [String]
}
