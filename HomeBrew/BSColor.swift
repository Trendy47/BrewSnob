//
//  UIColors.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 5/7/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation
import UIKit

class BSColor {
    
    static func brewSnobGreen() -> Int {
        return 0x7FB27F //0x71855A
    }
    
    static func brewSnobMintGreen() -> Int {
        return 0x7FB27F
    }
    
    static func brewSnobBackgroundColor() -> Int {
        return 0xDFFFEA //0x7E786A
    }
    
    static func brewSnobBrown() -> Int {
        return 0x7E786A //0x74483D
    }
    
    static func brewSnobGrey() -> Int {
        return 0xD8D6D2 //0xBEBBB4
    }
    
    static func brewSnobBlack() -> Int {
        return 0x4C4C4C
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}