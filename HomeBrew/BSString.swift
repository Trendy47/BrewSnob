//
//  BCString.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 6/9/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation

class BSString {
    
    static func recipesPath() -> URL {
        
        let fileManager = FileManager.default
        
        let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        
        let customBeerPath = documentsPath.appendingPathComponent("Recipes")
        
        do {
            try fileManager.createDirectory(atPath: customBeerPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }
        
        return customBeerPath
    }
}

extension String {
    func createSubfolderAt(_ location: FileManager.SearchPathDirectory) -> Bool {
        guard let locationUrl = FileManager().urls(for: location, in:.userDomainMask).first else { return false }
        do {
            try FileManager().createDirectory(at: locationUrl.appendingPathComponent(self), withIntermediateDirectories: false, attributes: nil)
            return true
        } catch let error as NSError {
            print(error.description)
            return false
        }
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
