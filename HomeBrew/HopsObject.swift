//
//  HopsObject.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 3/14/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation

class HopsObject {
    
    static let sharedInstance = HopsObject()
    
    var weight: String?
    var variety: String?
    var type: String?
    var usage: String?
    var time: String?
    var aa: String?
    var ibu: String?
    
    var hops: NSMutableArray = []
    
    func createObject(_ dictionary: NSDictionary, index: Int) {
        weight = dictionary["weight"] as? String
        variety = dictionary["variety"] as? String
        type = dictionary["type"] as? String
        usage = dictionary["usage"] as? String
        time = dictionary["time"] as? String
        aa = dictionary["aa"] as? String
        ibu = dictionary["ibu"] as? String
        
        if (index == -1) {
            hops.add(dictionary)
        } else {
            hops.insert(dictionary, at: index)
        }
    }
    
    func clearHops() {
        if (hops.count > 0) {
            hops = []
        }
    }
}
