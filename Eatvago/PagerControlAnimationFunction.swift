//
//  PagerControlAnimationFunction.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/25.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit

extension NearbyViewController {
    
    func pagerViewControl(swipeRight: Bool) {
        
        switch pagerViewControlRedPoint {
            
        case 1:
            
            if swipeRight == true {
                
                self.pagerViewControlRedPoint += 1
                
                secondPagerViewControlView.backgroundColor = UIColor.red
                firstPagerViewControlView.backgroundColor = UIColor(red: 230.0/255.0,
                                                                    green: 255.0/255.0,
                                                                    blue: 255.0/255.0,
                                                                    alpha: 0.9)
                
                thirdPagerViewControlView.backgroundColor = UIColor(red: 230.0/255.0,
                                                                    green: 255.0/255.0,
                                                                    blue: 255.0/255.0,
                                                                    alpha: 0.9)
                
                break
                
            } else {
                
                self.tempPagerControlBigPointView.frame = self.firstPagerViewControlView.frame
                
                self.tempPagerControlBigPointView.backgroundColor = UIColor(red: 230.0/255.0,
                                                                            green: 255.0/255.0,
                                                                            blue: 255.0/255.0,
                                                                            alpha: 0.9)
                
                self.tempPagerControlBigPointView.layer.cornerRadius = self.tempPagerControlBigPointView.width / 2
                
                self.tempPagerControlBigPointView.clipsToBounds = true
                
                self.tempPagerControlLittlePointView.frame = self.firstLeftOnePagerViewControlView.frame
                
                self.tempPagerControlLittlePointView.backgroundColor = UIColor.red
                
                self.tempPagerControlLittlePointView.layer.cornerRadius = self.tempPagerControlLittlePointView.width / 2
                
                self.tempPagerControlLittlePointView.clipsToBounds = true
                
                self.view.addSubview(tempPagerControlBigPointView)
                
                self.view.addSubview(tempPagerControlLittlePointView)
                
                UIView.animate(withDuration: 0.4, delay: 0.05, options: .curveEaseOut, animations: {
                    
                    self.tempPagerControlLittlePointView.frame = self.tempPagerControlBigPointView.frame
                    
                    self.tempPagerControlLittlePointView.layer.cornerRadius = self.tempPagerControlLittlePointView.width / 2
                    
                    self.tempPagerControlLittlePointView.clipsToBounds = true
                    
                }, completion: { (_) in
                    
                    self.tempPagerControlBigPointView.removeFromSuperview()
                    
                    self.tempPagerControlLittlePointView.removeFromSuperview()
                    
                })
                
            }
            
        case 2:
            
            if swipeRight == true {
                
                self.pagerViewControlRedPoint += 1
                
                thirdPagerViewControlView.backgroundColor = UIColor.red
                
                secondPagerViewControlView.backgroundColor = UIColor(red: 230.0/255.0,
                                                                     green: 255.0/255.0,
                                                                     blue: 255.0/255.0,
                                                                     alpha: 0.9)
                
                firstPagerViewControlView.backgroundColor = UIColor(red: 230.0/255.0,
                                                                    green: 255.0/255.0,
                                                                    blue: 255.0/255.0,
                                                                    alpha: 0.9)
                
                break
                
            } else {
                
                self.pagerViewControlRedPoint -= 1
                
                firstPagerViewControlView.backgroundColor = UIColor.red
                
                thirdPagerViewControlView.backgroundColor = UIColor(red: 230.0/255.0,
                                                                    green: 255.0/255.0,
                                                                    blue: 255.0/255.0,
                                                                    alpha: 0.9)
                
                secondPagerViewControlView.backgroundColor = UIColor(red: 230.0/255.0,
                                                                     green: 255.0/255.0,
                                                                     blue: 255.0/255.0,
                                                                     alpha: 0.9)
                
                break
                
            }
            
        case 3:
            
            if swipeRight == true {
                
                self.tempPagerControlBigPointView.frame = self.thirdPagerViewControlView.frame
                
                self.tempPagerControlBigPointView.backgroundColor = UIColor(red: 230.0/255.0,
                                                                            green: 255.0/255.0,
                                                                            blue: 255.0/255.0,
                                                                            alpha: 0.9)
                
                self.tempPagerControlBigPointView.layer.cornerRadius = self.tempPagerControlBigPointView.width / 2
                
                self.tempPagerControlBigPointView.clipsToBounds = true
                
                self.tempPagerControlLittlePointView.frame = self.thirdRightOnePagerViewControlView.frame
                
                self.tempPagerControlLittlePointView.backgroundColor = UIColor.red
                
                self.tempPagerControlLittlePointView.layer.cornerRadius = self.tempPagerControlLittlePointView.width / 2
                
                self.tempPagerControlLittlePointView.clipsToBounds = true
                
                self.view.addSubview(tempPagerControlBigPointView)
                
                self.view.addSubview(tempPagerControlLittlePointView)
                
                UIView.animate(withDuration: 0.4, delay: 0.05, options: .curveEaseOut, animations: {
                    
                    self.tempPagerControlLittlePointView.frame = self.tempPagerControlBigPointView.frame
                    
                    self.tempPagerControlLittlePointView.layer.cornerRadius = self.tempPagerControlLittlePointView.width / 2
                    
                    self.tempPagerControlLittlePointView.clipsToBounds = true
                    
                }, completion: { (_) in
                    
                    self.tempPagerControlBigPointView.removeFromSuperview()
                    
                    self.tempPagerControlLittlePointView.removeFromSuperview()
                    
                })
                
            } else {
                
                self.pagerViewControlRedPoint -= 1
                
                secondPagerViewControlView.backgroundColor = UIColor.red
                
                firstPagerViewControlView.backgroundColor = UIColor(red: 230.0/255.0,
                                                                    green: 255.0/255.0,
                                                                    blue: 255.0/255.0,
                                                                    alpha: 0.9)
                
                thirdPagerViewControlView.backgroundColor = UIColor(red: 230.0/255.0,
                                                                    green: 255.0/255.0,
                                                                    blue: 255.0/255.0,
                                                                    alpha: 0.9)
                
                break
                
            }
            
        default: break
            
        }
        
    }
    
    func callPageControlBaseOnIndex(_ index: Int) {
        
        if pagerViewLastIndex == index - 1 {
            
            pagerViewControl(swipeRight: true)
            
            pagerViewLastIndex = index
            
        } else if pagerViewLastIndex == index + 1 {
            
            pagerViewControl(swipeRight: false)
            
            pagerViewLastIndex = index
            
        } else if pagerViewLastIndex > index {
            
            pagerViewControl(swipeRight: true)
            
            pagerViewLastIndex = index
            
        } else if index > pagerViewLastIndex {
            
            pagerViewControl(swipeRight: false)
            
            pagerViewLastIndex = index
            
        }
        
    }
    
}
