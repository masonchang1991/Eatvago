//
//  NearbyMapTableViewCell.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/7/27.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class NearbyMapTableViewCell: UITableViewCell, NVActivityIndicatorViewable {

    @IBOutlet weak var mapTextLabel: UILabel!
    
    @IBOutlet weak var distanceText: UILabel!
    
    @IBOutlet weak var durationText: UILabel!
    
    @IBOutlet weak var storePhotoView: NVActivityIndicatorView!
    
    @IBOutlet weak var storePhotoImageView: UIImageView!
    
    @IBOutlet weak var showStoreDetailButton: UIButton!
    
    @IBOutlet weak var addToList: UIButton!

    
}
