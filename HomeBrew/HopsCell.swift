//
//  HopsCell.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 3/14/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import QuartzCore
import UIKit

class HopsCell : UITableViewCell {
    
    @IBOutlet weak var varietyLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var usageLabel: UILabel!
    @IBOutlet weak var aaLabel: UILabel!
    @IBOutlet weak var ibuLabel: UILabel!
    
    func createHopsCell(_ dictionary: NSDictionary) {
        let variety: String = (dictionary["variety"] as? String)!
        let weight: Float = (dictionary["weight"] as? Float)!
        let aa: Float = (dictionary["aa"] as? Float)!
        let ibu: Float = (dictionary["ibu"] as? Float)!
        let type:String = (dictionary["type"] as? String)!
        let time: Float = (dictionary["time"] as? Float)!
        let usage: String = (dictionary["usage"] as? String)!
        let unit: String = (dictionary["unit"] as? String)!
        
        varietyLabel.text = variety
        weightLabel.text = String(format: "Weight: %.2f %@", arguments: [weight, (unit == "US" ? "oz" : "g")])
        aaLabel.text = String(format: "AA: %.1f", arguments: [aa])
        ibuLabel.text = String(format: "IBU: %.1f", arguments: [ibu])
        usageLabel.text = String(format: "Usage: %@", arguments: [usage])
        typeLabel.text = String(format: "Type: %@", arguments: [type])
        timeLabel.text = String(format: "Time: %.0f min", arguments: [time])
    }
}
