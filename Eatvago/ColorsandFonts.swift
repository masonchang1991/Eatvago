//
//  ColorsandFonts.swift
//  Patissier
//
//  Created by Ｍason Chang on 2017/6/22.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import Foundation
import UIKit

// Color palette

extension UIColor {
    class var asiSandBrown: UIColor {
        return UIColor(red: 211.0 / 255.0, green: 150.0 / 255.0, blue: 104.0 / 255.0, alpha: 1.0)
    }

    class var asiBrownish: UIColor {
        return UIColor(red: 160.0 / 255.0, green: 98.0 / 255.0, blue: 90.0 / 255.0, alpha: 1.0)
    }

    class var asiDarkSalmon: UIColor {
        return UIColor(red: 204.0 / 255.0, green: 113.0 / 255.0, blue: 93.0 / 255.0, alpha: 1.0)
    }

    class var asiDarkSand: UIColor {
        return UIColor(red: 166.0 / 255.0, green: 145.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
    }

    class var asiPaleTwo: UIColor {
        return UIColor(red: 254.0 / 255.0, green: 241.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
    }

    class var asiPaleGold: UIColor {
        return UIColor(red: 251.0 / 255.0, green: 197.0 / 255.0, blue: 111.0 / 255.0, alpha: 1.0)
    }

    class var asiDenimBlue: UIColor {
        return UIColor(red: 59.0 / 255.0, green: 89.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
    }

    class var asiCoolGrey: UIColor {
        return UIColor(red: 171.0 / 255.0, green: 179.0 / 255.0, blue: 176.0 / 255.0, alpha: 1.0)
    }

    class var asiPale: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 239.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    }

    class var asiDustyOrange: UIColor {
        return UIColor(red: 237.0 / 255.0, green: 96.0 / 255.0, blue: 81.0 / 255.0, alpha: 1.0)
    }

    class var asiSlate: UIColor {
        return UIColor(red: 67.0 / 255.0, green: 87.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0)
    }

    class var asiDarkBlueGrey: UIColor {
        return UIColor(red: 8.0 / 255.0, green: 20.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
    }

    class var asiGreyish: UIColor {
        return UIColor(white: 178.0 / 255.0, alpha: 1.0)
    }

    class var asiCoolGreyTwo: UIColor {
        return UIColor(red: 165.0 / 255.0, green: 170.0 / 255.0, blue: 178.0 / 255.0, alpha: 1.0)
    }

    class var asiDarkishBlue: UIColor {
        return UIColor(red: 3.0 / 255.0, green: 63.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0)
    }

    class var asiSeaBlue: UIColor {
        return UIColor(red: 4.0 / 255.0, green: 107.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0)
    }

    class var asiCharcoalGrey: UIColor {
        return UIColor(white: 74.0 / 255.0, alpha: 1.0)
    }
    class var asiGreyishBrown: UIColor {
        return UIColor(red: 82.0 / 255.0, green: 66.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
    }

    class var asiWhiteTwo: UIColor {
        return UIColor(white: 250.0 / 255.0, alpha: 1.0)
    }

    class var asiTealish85: UIColor {
        return UIColor(red: 53.0 / 255.0, green: 184.0 / 255.0, blue: 208.0 / 255.0, alpha: 0.85)
    }
    class var asiBlack50: UIColor {
        return UIColor(white: 0.0, alpha: 0.5)
    }
}

// Text styles

extension UIFont {
    class func asiTextStyle3Font() -> UIFont? {
        return UIFont(name: "Helvetica-Bold", size: 80.0)
    }

    class func asiTextStyleFont() -> UIFont? {
        return UIFont(name: "PingFangTC-Medium", size: 20.0)
    }

    class func asiTextStyle2Font() -> UIFont? {
        return UIFont(name: "PingFangTC-Regular", size: 14.0)
    }

    class func asiTextStyle4Font() -> UIFont {
        return UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightRegular)
    }

    class func asiTextStyle6Font() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 12.0)
    }
    class func asiTextStyle5Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 14.0)
    }

    class func asiTextStyle8Font() -> UIFont {
        return UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightSemibold)
    }

    class func asiTextStyle10Font() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 12.0)
    }

    class func asiTextStyle9Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 14.0)
    }

    class func asiTextStyle11Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 16.0)
    }
    class func asiTextStyle13Font() -> UIFont {
        return UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightBold)
    }
    class func asiTextStyle12Font() -> UIFont {
        return UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightRegular)
    }
    class func asiTextStyle14Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 18.0)
    }
    class func asiTextStyle15Font() -> UIFont {
        return UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightRegular)
    }
    class func asiTextStyle16Font() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 12.0)
    }
    class func asiTextStyle17Font() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 12.0)
    }
    class func asiTextStyle19Font() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 24.0)
    }
    class func asiTextStyle21Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 12.0)
    }
    class func asiTextStyle20Font() -> UIFont {
        return UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightRegular)
    }
    class func asiTextStyle18Font() -> UIFont? {
        return UIFont(name: "Georgia", size: 12.0)
    }
    class func asiTextStyle22Font() -> UIFont {
        return UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightSemibold)
    }
    class func asiTextStyleXFont() -> UIFont? {
        return UIFont(name: "LuxiMono", size: 18.0)
    }

}

extension CAGradientLayer {
    class func gradientLayerForBounds(bounds: CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        return layer
    }
}

extension UILabel {
    func addCharactersSpacing( spacing: CGFloat, text: String ) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute( NSKernAttributeName, value: spacing, range: NSRange(location: 0, length: text.characters.count ))
        self.attributedText = attributedString
    }
}

extension UILabel {
    func addTextSpacing() {
        if let textString = text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSKernAttributeName, value: 0.1, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
