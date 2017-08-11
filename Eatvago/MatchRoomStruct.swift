//
//  MatchRoomStruct.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/10.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//
import UIKit

struct MatchRoom {
    
    var owner: String
    
    var ownerLocationLat: String
    
    var ownerLocationLon: String
    
    var ownerMatchInfo: String
    
    var attender: String
    
    var attenderLocationLat: String
    
    var attenderLocationLon: String
    
    var attenderMatchInfo: String
    
    var connection: String?
    
}


struct MatchPeopleInfo {
    
    var oppositePeopleName: String
    
    var oppositePeopleGender: String
    
    var oppositePeopleText: String
    
    var oppositePeopleImage: UIImageView

}
