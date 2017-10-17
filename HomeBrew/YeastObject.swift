//
//  YeastObject.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 3/19/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation

class YeastObject {
    
    var name: String?
    var attenuation: Float?
    
    init(_ dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        attenuation = dictionary["attenuation"] as? Float
    }
}
