//
//  FermentableObject.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 3/12/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation

class FermentableObject {
    
    var weight: String?
    var name: String?
    var ppg: String?
    var L: String?
    var usage: String?
    
    init(_ dictionary: NSDictionary) {
        weight = dictionary["weight"] as? String
        name = dictionary["name"] as? String
        ppg = dictionary["ppg"] as? String
        L = dictionary["L"] as? String
        usage = dictionary["usage"] as? String
    }
}
