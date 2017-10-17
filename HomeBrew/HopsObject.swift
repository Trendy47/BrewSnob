//
//  HopsObject.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 3/14/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation

class HopsObject {
    
    var weight: String?
    var variety: String?
    var type: String?
    var usage: String?
    var time: String?
    var aa: String?
    var ibu: String?
    
    init(_ dictionary: NSDictionary) {
        weight = dictionary["weight"] as? String
        variety = dictionary["variety"] as? String
        type = dictionary["type"] as? String
        usage = dictionary["usage"] as? String
        time = dictionary["time"] as? String
        aa = dictionary["aa"] as? String
        ibu = dictionary["ibu"] as? String
    }
}
