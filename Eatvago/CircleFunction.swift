//
//  CircleFunction.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/2.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath()
        
        let radius: Double = Double(rect.width - 20) / 2
        
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        
        path.move(to: CGPoint(x: center.x + CGFloat(radius), y: center.y))
        
        path.move(to: CGPoint(x: center.x + CGFloat(radius), y: center.y))
        
        for point in stride(from: 0, to: 361.0, by: 40) {
            
            let radians = point * Double.pi / 180
            
            let x = Double(center.x) + radius * cos(radians)
            let y = Double(center.y) + radius * sin(radians)

            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        for point in stride(from: 0, to: 360.0, by: 40) {
            
            let radians = point * Double.pi / 180
            
            let x = Double(center.x) + radius * cos(radians)
            let y = Double(center.y) + radius * sin(radians)
            path.addLine(to: center)
        }
        
            path.lineWidth = 5
            path.stroke()
        
    }
    
}
