//
//  FermentableCell.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 3/13/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import QuartzCore
import UIKit

class FermentableCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var ppgLabel: UILabel!
    @IBOutlet weak var flvLabel: UILabel!
    @IBOutlet weak var usageLabel: UILabel!
    
    func createFermentableCell(_ dictionary: NSDictionary) {
        let name: String = (dictionary["name"] as? String)!
        let weight: Float = (dictionary["weight"] as? Float)!
        let ppg: Float = (dictionary["ppg"] as? Float)!
        let l: Float = (dictionary["L"] as? Float)!
        let usage: String = (dictionary["usage"] as? String)!
        let unit: String = (dictionary["unit"] as? String)!
        let x: String? = (unit == "US" ? "lb" : "kg")
        
        nameLabel.text = name
        weightLabel.text = String(format: "Weight: %.2f %@", arguments: [weight, x!])
        ppgLabel.text = String(format: "PPG: %.0f", arguments: [ppg])
        flvLabel.text = String(format: "L°: %.0f", arguments: [l])
        usageLabel.text = String(format: "Usage: %@", arguments: [usage])
    }
}
