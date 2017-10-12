//
//  BeerRecipeTableViewCell.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 2/23/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import UIKit
import QuartzCore

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellTextLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    let imageArray = ["beer_glass.png", "beer_mug.png", "beer_mug2.png", "beer_pint.png", "beer_pint2.png", "two_beers.png"]
    
    func useBeer(_ beer: Beer) {
        cellTextLabel.text = beer.beerName
        cellTextLabel.textColor = UIColor.black
        cellTextLabel.font = UIFont.systemFont(ofSize: 18)
        
        let randomIndex = Int(arc4random_uniform(UInt32(imageArray.count)))
        let imageName = imageArray[randomIndex]
        
        iconImageView.image = UIImage(named: imageName)
    }
    
    func useTool(_ name: String, _ imageName: String) {
        cellTextLabel.text = name
        cellTextLabel.textColor = UIColor.black
        cellTextLabel.font = UIFont.systemFont(ofSize: 18)
        
        iconImageView.image = UIImage(named: imageName)
    }
}
