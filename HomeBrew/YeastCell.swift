//
//  YeastCell.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 3/19/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation
import UIKit

class YeastCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var attenuationLabel: UILabel!
    
    func createYeastCell(_ dictionary: NSDictionary) {
        let name: String = (dictionary["name"] as? String)!
        let attenuation: Float = (dictionary["attenuation"] as? Float)!
        
        self.nameLabel.text = name
        self.attenuationLabel.text = String(format: "%0.f", arguments: [attenuation])
    }
}
