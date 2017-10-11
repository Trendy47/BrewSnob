//
//  BSView.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 8/7/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [10.0, -10.0, 10.0, -10.0, 5.0, -5.0, 2.5, -2.5, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
