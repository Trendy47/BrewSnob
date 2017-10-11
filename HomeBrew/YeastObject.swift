//
//  YeastObject.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 3/19/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation

class YeastObject {
    
    static let sharedInstance = YeastObject()
    
    var name: String?
    var attenuation: Float?
    
    var yeasts: NSMutableArray = []
    
    func createObject(_ dictionary: NSDictionary, index: Int) {
        name = dictionary["name"] as? String
        attenuation = dictionary["attenuation"] as? Float
        
        if (index == -1) {
            yeasts.add(dictionary)
        } else {
            yeasts.insert(dictionary, at: index)
        }
    }
    
    func clearYeasts() {
        if (yeasts.count > 0) {
            yeasts = []
        }
    }
}
