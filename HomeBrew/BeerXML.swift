//
//  BeerXML.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 6/11/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation

class BeerXML {
    
    static let sharedInstance = BeerXML()
    
    // Unused class until AEXML is updated for Swift 3
//    let attributes = ["xmlns:xsi" : "http://www.w3.org/2001/XMLSchema-instance", "xmlns:xsd" : "http://www.w3.org/2001/XMLSchema"]
//
//    func writeToXMLFile(_ beerDict: NSDictionary) {
//        
//        let recipeObject = CustomRecipeObject.sharedInstance
//        
//        let beerName = beerDict.object(forKey: "name") as? String
//        let filePath = BSString.recipesPath().absoluteURL.appendingPathComponent(beerName!+".xml").path
//        
//        if (FileManager.default.fileExists(atPath: filePath)) {
//            return
//        }
//        
//        // get dictionary variables
//        let recipeType = beerDict.object(forKey: "recipeType") as? String
//        var batchSize = beerDict.object(forKey: "batchSize")
//        var boilSize = beerDict.object(forKey: "boilSize")
//        let boilTime = beerDict.object(forKey: "boilTime") as? String
//        let efficiency = beerDict.object(forKey: "efficiency") as? String
//        
//        let originalGrav = beerDict.object(forKey: "ograv") as? String
//        let finalGrav = beerDict.object(forKey: "fgrav") as? String
////        let abv = beerDict.objectForKey("abv") as? String
////        let ibu = beerDict.objectForKey("ibu") as? String
////        let srm = beerDict.objectForKey("srm") as? String
//        
//        let fermentString = beerDict.object(forKey: "fermentables") as? String
//        let hopsString = beerDict.object(forKey: "hops") as? String
//        let yeastString = beerDict.object(forKey: "yeasts") as? String
//        
//        let ingredients = beerDict.object(forKey: "ingredients") as? String
////        let directions = beerDict.objectForKey("directions") as? String
//        
//        let unit = beerDict.object(forKey: "unit") as? String
//        if unit == "us" {
//            // convert to kg
//            batchSize = recipeObject.convertGallonsToLiters(((batchSize as AnyObject).floatValue)!)
//            boilSize = recipeObject.convertGallonsToLiters(((boilSize as AnyObject).floatValue)!)
//        }
//        
//        /* create xml file */
//        
//        // xml document
//        let recipeRequest = AEXMLDocument()
//        
//        // encapsulating element
//        let recipes = recipeRequest.addChild(name: "RECIPES")
//        let recipe = recipes.addChild(name: "RECIPE")
//        
//        recipe.addChild(name: "WATER") // empty element
//        recipe.addChild(name: "EQUIPMENT") // empty element
//        recipe.addChild(name: "NAME", value: beerName)
//        recipe.addChild(name: "VERSION", value: "1")
//        recipe.addChild(name: "TYPE", value: recipeType)
//        recipe.addChild(name: "BREWER") //empty element
//        recipe.addChild(name: "BATCH_SIZE", value: "\(batchSize)")
//        recipe.addChild(name: "BOIL_SIZE", value: "\(boilSize)")
//        recipe.addChild(name: "BOIL_TIME", value: boilTime)
//        recipe.addChild(name: "EFFICIENY", value: efficiency)
//        recipe.addChild(name: "OG", value: originalGrav)
//        recipe.addChild(name: "FG", value: finalGrav)
//        recipe.addChild(name: "NOTES") // empty element
//        recipe.addChild(name: "IBU_METHOD", value: "Tinseth")
//        
//        // parse hops string into separate hop elements
//        let hops = recipe.addChild(name: "HOPS")
//        for singleHop in (hopsString?.components(separatedBy: "\n"))! {
//            
//            let hop = hops.addChild(name: "HOP")
//            
//            let components = singleHop.components(separatedBy: " / ")
//            let weightunit = components[0].components(separatedBy: " of ")[0]
//            var weight = (weightunit.components(separatedBy: " ")[0] as String).floatValue
//            let unit: String? = weightunit.components(separatedBy: " ")[1]
//            let name: String? = components[0].components(separatedBy: " of ")[1]
//            let usage: String? = components[2].components(separatedBy: " @ ")[0]
//            let aa: String? = components[3].components(separatedBy: " AA")[0]
//            let time: String? = components[2].components(separatedBy: " @ ")[1].components(separatedBy: " min")[0]
//            
//            if unit == "us" {
//                weight = recipeObject.convertOuncesToGrams(weight)
//            }
//            
//            hop.addChild(name: "NAME", value: name)
//            hop.addChild(name: "VERSION", value: "1")
//            hop.addChild(name: "ALPHA", value: aa)
//            hop.addChild(name: "AMOUNT", value: "\(weight)")
//            hop.addChild(name: "USE", value: usage)
//            hop.addChild(name: "TIME", value: time)
//        }
//        
//        let fermemtables = recipe.addChild(name: "FERMENTABLES")
//        for singleFerment in (fermentString?.components(separatedBy: "\n"))! {
//            
//            let fermentable = fermemtables.addChild(name: "FERMENTABLE")
//            
//            let components = singleFerment.components(separatedBy: " / ")
//            let weightunit = components[0].components(separatedBy: " of ")[0]
//            var weight = (weightunit.components(separatedBy: " ")[0] as String).floatValue
//            let unit: String? = weightunit.components(separatedBy: " ")[1]
//            let name: String? = components[0].components(separatedBy: " lb of ")[1]
//            let ppg: String? = components[1].components(separatedBy: " ppg")[0]
//            let lovi: String? = components[2].components(separatedBy: " L°")[0]
//            //let usage: String? = components[3]
//            
//            if unit == "us" {
//                weight = recipeObject.convertPoudnsToKilos(weight)
//            }
//            
//            fermentable.addChild(name: "NAME", value: name)
//            fermentable.addChild(name: "VERSION", value: "1")
//            fermentable.addChild(name: "AMOUNT", value: "\(weight)")
//            fermentable.addChild(name: "TYPE") // empty element until I get database working
//            fermentable.addChild(name: "YIELD", value: ppg)
//            fermentable.addChild(name: "COLOR", value: lovi)
//        }
//        
//        let yeasts = recipe.addChild(name: "YEASTS")
//        for singleYeast in (yeastString?.components(separatedBy: "\n"))! {
//            
//            let yeast = yeasts.addChild(name: "YEAST")
//            
//            let name: String? = singleYeast.components(separatedBy: " with ")[0]
//            let attenuation: String? = singleYeast.components(separatedBy: " with ")[1]
//            
//            yeast.addChild(name: "NAME", value: name)
//            yeast.addChild(name: "VERSION", value: "1")
//            yeast.addChild(name: "TYPE")  // empty element until I get database working
//            yeast.addChild(name: "FORM")  // empty element until I get database working
//            yeast.addChild(name: "ATTENUATION", value: attenuation)
//        }
//        
//        let miscs = recipe.addChild(name: "MISCS")
//        for singleMisc in (ingredients?.components(separatedBy: "\n"))! {
//            
//            let misc = miscs.addChild(name: "MISC")
//            
//            misc.addChild(name: "NAME", value: "")
//            misc.addChild(name: "VERSION", value: "1")
//            misc.addChild(name: "TYPE", value: "")
//            misc.addChild(name: "USE", value: "")
//            misc.addChild(name: "TIME", value: "")
//            misc.addChild(name: "AMOUNT", value: "")
//            misc.addChild(name: "NOTES", value: singleMisc)
//        }
//        
//        // style is the last element inside recipe
//        let style = recipe.addChild(name: "STYLE")
//        style.addChild(name: "NAME", value: beerName)
//        style.addChild(name: "VERSION", value: "1")
//        style.addChild(name: "CATEGORY_NUMBER", value: "")
//        style.addChild(name: "STYLE_LETTER", value: "")
//        style.addChild(name: "STYLE_GUIDE", value: "")
//        style.addChild(name: "TYPE", value: "")
//        style.addChild(name: "OG_MIN", value: "")
//        style.addChild(name: "OF_MAX", value: "")
//        style.addChild(name: "FG_MIN", value: "")
//        style.addChild(name: "FG_MAX", value: "")
//        style.addChild(name: "IBU_MIN", value: "")
//        style.addChild(name: "IBU_MAX", value: "")
//        style.addChild(name: "COLOR_MIN", value: "")
//        style.addChild(name: "COLOR_MAX", value: "")
//        
//        // end recipe
//        // end recipes
//        
//        /* end of xml doc */
//        
//        do {
//            let fileName = NSString(format: "/%@.xml", beerName!).replacingOccurrences(of: " ", with: "")
//            let xmlString = recipeRequest.xmlString
//
//            try xmlString.write(toFile: BSString.recipesPath().path + fileName, atomically: true, encoding: String.Encoding.utf8)
//            
//            print(xmlString)
//        } catch _ {
//            print("ERROR")
//        }
//    }
//    
//    func readXMLFile() {
//        
//    }
}
