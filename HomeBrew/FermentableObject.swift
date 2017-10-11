//
//  FermentableObject.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 3/12/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation

class FermentableObject {
    
    static let sharedInstance = FermentableObject()
    
    var weight: String?
    var name: String?
    var ppg: String?
    var L: String?
    var usage: String?
    
    var fermentables: NSMutableArray = []
    
    func createObject(_ dictionary: NSDictionary, index: Int) {
        weight = dictionary["weight"] as? String
        name = dictionary["name"] as? String
        ppg = dictionary["ppg"] as? String
        L = dictionary["L"] as? String
        usage = dictionary["usage"] as? String
        
        if (index == -1) {
            fermentables.add(dictionary)
        } else {
            fermentables.insert(dictionary, at: index)
        }
    }
    
    func clearFermentables() {
        if (fermentables.count > 0) {
            fermentables = []
        }
    }
}
