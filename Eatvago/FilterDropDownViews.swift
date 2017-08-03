//
//  FilterDropDownViewsViewController.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/3.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import YNDropDownMenu

class FilterDistanceView: YNDropDownView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initViews()
    }
    
    func initViews() {
        
    }
    
    @IBOutlet weak var distanceSlider: UISlider!

    @IBAction func distanceConfirm(_ sender: UIButton) {
        self.hideMenu()
        
    }

}
