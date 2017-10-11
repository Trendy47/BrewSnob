//
//  Beer.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 4/13/15.
//  Copyright (c) 2015 Chris Tirendi. All rights reserved.
//

import Foundation

class Beer {
    
    let beerName:String?
    let recipeType:String?
    let ingredients:String?
    let directions:String?
    let oGravity:String?
    let fGravity:String?
    let abv:String?
    let ibu:String?
    let srm:String?
    let batchSize:String?
    let boilSize:String?
    let boilTime:String?
    let efficiency:String?
    var fermentables:String = ""
    var hops:String = ""
    var yeasts:String = ""
    let unit:String?
    let beerDict:NSDictionary?
    
    init (dictionary: NSDictionary) {
        
        beerDict = dictionary
        
        beerName = beerDict?.value(forKey: "brewName") as! String?
        recipeType = beerDict?.value(forKey: "recipeType") as! String?
        oGravity = beerDict?.value(forKey: "og") as! String?
        fGravity = beerDict?.value(forKey: "fg") as! String?
        abv = beerDict?.value(forKey: "abv") as! String?
        ibu = beerDict?.value(forKey: "ibu") as! String?
        srm = beerDict?.value(forKey: "srm") as! String?
        
        batchSize = beerDict?.value(forKey: "batchSize") as! String?
        boilSize = beerDict?.value(forKey: "boilSize") as! String?
        boilTime = beerDict?.value(forKey: "boilTime") as! String?
        efficiency = beerDict?.value(forKey: "efficiency") as! String?
        unit = beerDict?.value(forKey: "unit") as! String?
        
        // add newlines to the text for text views
        let unescapedIngredients = beerDict?.value(forKey: "ingredients") as! String?
        ingredients = unescapedIngredients?.replacingOccurrences(of: "\\n", with:"\n")
                
        let unescapedDirections = beerDict?.value(forKey: "directions") as! String?
        directions = unescapedDirections?.replacingOccurrences(of: "\\n", with: "\n")
        
        let unescapedFerments = beerDict?.value(forKey: "fermentables") as! String?
        fermentables = (unescapedFerments?.replacingOccurrences(of: "\\n", with: "\n"))!
        
        let unescapedHops = beerDict?.value(forKey: "hops") as! String?
        hops = (unescapedHops?.replacingOccurrences(of: "\\n", with: "\n"))!
        
        let unescapedYeasts = beerDict?.value(forKey: "yeast") as! String?
        yeasts = (unescapedYeasts?.replacingOccurrences(of: "\\n", with: "\n"))!
        
//        let fArray: Array<JSON> = json["fermentables"].arrayValue
//        for fermentable in fArray.enumerated() {
//            fermentables += fermentable.element.stringValue + "\n"
//        }
//        
//        fermentables = fermentables.replacingOccurrences(of: "\\n", with: "\n")
//        
//        let hArray: Array<JSON> = json["hops"].arrayValue
//        for hop in hArray.enumerated() {
//            hops += hop.element.stringValue + "\n"
//        }
//        
//        hops = hops.replacingOccurrences(of: "\\n", with: "\n")
//        
//        let yArray: Array<JSON> = json["yeasts"].arrayValue
//        for yeast in yArray.enumerated() {
//            yeasts += yeast.element.stringValue + "\n"
//        }
//        
//        yeasts = yeasts.replacingOccurrences(of: "\\n", with: "\n")
    }
    
    class func loadRecipeFromFile(_ path:String) -> [Beer] {
        var recipes:[Beer] = []
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: [])
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                // Custom json files
                let recipeDictionary = json
                let recipe = Beer(dictionary: recipeDictionary)
                recipes.append(recipe)
            }
        } catch {
            print(error)
        }
        
        return recipes
    }
}
