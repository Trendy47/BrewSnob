//
//  BeerRepository.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 3/19/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation

class RecipeManager {
    
    static let sharedInstance = RecipeManager()
    
    var brewName: String?
    var recipeType: String?
    var originalGravity: Float = 0
    var finalGravity: Float = 0
    var batchSize: Float = 0
    var boilSize: Float = 0
    var boilTime: Float = 0
    var efficiency: Float = 0
    var finalABV: Float = 0
    var finalIBU: Float = 0
    var finalSRM: Float = 0
    var finalAttenuation: Float = 0
    var ingredients: String?
    var directions: String?
    var unit: String = "US"
    
    // list of objects
    var fermentList: NSMutableArray = []
    var hopList: NSMutableArray = []
    var yeastList: NSMutableArray = []
    
    // dictionaries for objects
    var fermentableObjects = Dictionary<String, AnyObject>()
    var hopsObjects = Dictionary<String, AnyObject>()
    var yeastObjects =  Dictionary<String, AnyObject>()
    
    var isMetric: Bool = false
    
    func calculateSpecifications() {
        // Reset values
        var tempbatchSize: Float = self.batchSize
        var tempboilSize: Float = self.boilSize
        var tempOrgGrav: Float = 0
        var tempsrm: Float = 0
        var tempattenuation: Float = 0
        var totalibu: Float = 0
        
        let steepEff: Float = 0.50
        
        if (unit == "Metric") {
            tempbatchSize = convertLitersToGallons(tempbatchSize)
            tempboilSize = convertLitersToGallons(tempboilSize)
        } else {
            unit = "US"
        }
        
        // Get attenuation
        if (yeastList.count > 0) {
            for yeast in yeastList {
                let dict = (yeast as AnyObject)
                let attenuation: Float = (dict["attenuation"] as? Float)! / 100
                tempattenuation += attenuation
            }
        } else {
            tempattenuation = 0.75
        }
        
        /* Original Gravity
        * SGP = [W * EP * EE / V]
        * MCU = (Grain Color * Grain Weight lbs.) / Volume in Gallons
        * SRM = 1.49 * (MCU * 0.69)
        */
     
        for dictionary in fermentList {
            let dict = (dictionary as AnyObject)
            
            var weight: Float = (dict["weight"] as? Float)!
            let ppg: Float = (dict["ppg"] as? Float)!
            let lovibond: Float = (dict["L"] as? Float)!
            let fermentUnit: String = (dict["unit"] as? String)!
            let fUse: String = (dict["usage"] as? String)!
            
            var tempEff: Float = (fUse == "Extract" || fUse == "Late") ? 1.00 : fUse == "Steep" ? steepEff : self.efficiency
            tempEff /= 100
            
            if (fermentUnit == "Metric") {
                weight = convertKiloToPounds(weight)
            }
            
            let gp:Float = (weight * ppg * tempEff) / tempbatchSize
            tempOrgGrav += gp
            
            tempsrm += (weight * lovibond) / tempbatchSize
        }
        
        let numberOfPlaces: Float = 3.0
        var multiplier = pow(10.0, numberOfPlaces)
        var num = 1 + tempOrgGrav / 1000
        let og = round(num * multiplier) / multiplier
    
        self.originalGravity = og
        self.finalSRM = tempsrm <= 0 ? 0 : 1.49 * pow(tempsrm, 0.69)
        
        /* Final Gravity
        * FG = 1 + ((og * (1 - AP)) / 1000)
        */
        
        let tempFinalGrav: Float = (tempOrgGrav * (1 - tempattenuation))
        
        multiplier = pow(10.0, numberOfPlaces)
        num = 1 + tempFinalGrav / 1000
        let fg: Float = round(num * multiplier) / multiplier
        self.finalGravity = fg
        
        /*
        * ABV = (((og - fg) * 1.05) / fg) / 0.79
        */
        
        //let abv: Float = (((tempOrgGrav - tempFinalGrav) * 1.05) / tempFinalGrav) / 0.79 - 
        // Brewgr formula was giving me weird numbers
        
        let abv: Float = (self.originalGravity - self.finalGravity) * 131
        self.finalABV = abv
        
        /*
        * IBU
        */
        
        for hop in hopList {
            let ibu = (hop as AnyObject)["ibu"]
            totalibu += ibu as! Float
        }
        
        self.finalIBU = totalibu
    }
    
    func calculateBitterness(_ alpha: Float, weight: Float, time: Float, unit: String, type: String) -> Float {
        let sg: Float = self.originalGravity
        var batch: Float = self.batchSize
        var boil: Float = self.boilSize
        
        if (sg == 0 || batch == 0 || boil == 0) {
            return 0.0
        }
        
        var mutableWeight: Float = weight
        var bitterness: Float = 0
        
        if (unit == "Metric") {
            batch = convertLitersToGallons(batch)
            boil = convertLitersToGallons(boil)
            mutableWeight = convertGramsToOunces(weight)
        }
        
        let gravity: Float = (batch / boil) * (sg - 1)
        let bignessFactor: Float = 1.65 * pow(0.000125, gravity)
        let boilTimeFactor: Float = (1 - pow(2.718281828459045235, (-0.04 * time))) / 4.15
        var utilization: Float = bignessFactor * boilTimeFactor
        
        // if hop pellets multiply utilization by 1.1
        if (type == "Pellet") {
            utilization *= 1.1
        }
        
        if (type == "Dry Hop") {
            return 0.0
        }
        
        bitterness = (alpha * mutableWeight) * utilization * 74.90 / batch
        return bitterness
    }
    
    func createFermentablesStrings() -> String {
        var fermentablesStr = ""
        
        for dictionary in fermentList {
            let dict = (dictionary as AnyObject)
            
            let fname = dict["name"] as! String
            let fweight = dict["weight"] as! Float
            let fppg = dict["ppg"] as! Float
            let fl = dict["L"] as! Float
            let fusage = dict["usage"] as! String
            let funit = dict["unit"] as! String
            
            let a = (funit == "US" ? "lb" : "kg")
            let ftemp: String = String(format: "%.1f %@ of %@ / %.0f ppg / %.0f L° / %@", arguments:
                [fweight, a, fname, fppg, fl, fusage])
            
            fermentablesStr += ftemp + "\n"
        }
        
        return fermentablesStr
    }
    
    func createHopsString() -> String {
        var hopsStr = ""
        
        for dictionary in hopList {
            let dict = (dictionary as AnyObject)
            
            let hname = dict["variety"] as! String
            let hweight = dict["weight"] as! Float
            let hibu = dict["ibu"] as! Float
            let haa = dict["aa"] as! Float
            let htype = dict["type"] as! String
            let htime = dict["time"] as! Float
            let husage = dict["usage"] as! String
            let hunit = dict["unit"] as! String
            
            let b = (hunit == "US" ? "oz" : "g")
            let htemp: String = String(format: "%.1f %@ of %@ / %@ / %@ @ %.0f min / %.1f AA / %.1f IBU", arguments: [hweight, b, hname, htype, husage, htime, haa, hibu])
            
            hopsStr += htemp + "\n"
        }
        
        return hopsStr
    }
    
    func createYeastString() -> String {
        var yeastStr = ""
        
        for dictionary in yeastList {
            let dict = (dictionary as AnyObject)
            
            let yname = dict["name"] as! String
            let yattenuation = dict["attenuation"] as! Float
            
            let ytemp: String = String(format: "%@ with %.0f Attenuation", arguments:[yname, yattenuation])
            
            yeastStr += ytemp + "\n"
        }
        
        return yeastStr
    }
    
    func createBeerRecipe() -> Bool {
        var isCreated: Bool
        
        // calculate Values
        calculateSpecifications()
        
        let brewName: String? = self.brewName
        let recipeType: String? = self.recipeType
        let batchSize: String? = String(format: "%.1f", arguments: [self.batchSize])
        let boilSize: String? = String(format: "%.1f", arguments: [self.boilSize])
        let boilTime: String? = String(format: "%.1f", arguments: [self.boilTime])
        let efficiency: String? = String(format: "%.0f", arguments: [self.efficiency])
        let orgGravity: String? = String(format: "%.3f", arguments: [self.originalGravity])
        let finGravity: String? = String(format: "%.3f", arguments: [self.finalGravity])
        let abv: String? = String(format: "%.1f", arguments: [self.finalABV])
        let ibu: String? = String(format: "%.1f", arguments: [self.finalIBU])
        let srm: String? = String(format: "%.1f", arguments: [self.finalSRM])
        var ing: String? = self.ingredients
        var dir: String? = self.directions
        let unit: String? = self.unit
        
        if (dir == nil) {
            dir = "None"
        }
        
        if (ing == nil) {
            ing = "None"
        }
        
        let fermentables: String? = createFermentablesStrings()
        let hops: String? = createHopsString()
        let yeast: String? = createYeastString()
    
        let dict: NSMutableDictionary? = [:]
        dict?.setObject(brewName!, forKey: "brewName" as NSCopying)
        dict?.setObject(recipeType!, forKey: "recipeType" as NSCopying)
        dict?.setObject(batchSize!, forKey: "batchSize" as NSCopying)
        dict?.setObject(boilSize!, forKey: "boilSize" as NSCopying)
        dict?.setObject(boilTime!, forKey: "boilTime" as NSCopying)
        dict?.setObject(efficiency!, forKey: "efficiency" as NSCopying)
        dict?.setObject(orgGravity!, forKey: "og" as NSCopying)
        dict?.setObject(finGravity!, forKey: "fg" as NSCopying)
        dict?.setObject(abv!, forKey: "abv" as NSCopying)
        dict?.setObject(ibu!, forKey: "ibu" as NSCopying)
        dict?.setObject(srm!, forKey: "srm" as NSCopying)
        dict?.setObject(ing!, forKey: "ingredients" as NSCopying)
        dict?.setObject(dir!, forKey: "directions" as NSCopying)
        dict?.setObject(unit!, forKey: "unit" as NSCopying)
        dict?.setObject(fermentables!, forKey: "fermentables" as NSCopying)
        dict?.setObject(hops!, forKey: "hops" as NSCopying)
        dict?.setObject(yeast!, forKey: "yeast" as NSCopying)
        
        //BeerXML.sharedInstance.writeToXMLFile(jsonObject)
        
        let jsonObject: AnyObject = dict!
    
        let jsonData: Data
        do {
            
            let options = JSONSerialization.WritingOptions.prettyPrinted
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
            
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            let fileName = NSString(format: "/%@.json", brewName!).replacingOccurrences(of: " ", with: "")
            
            try? jsonData.write(to: URL(fileURLWithPath: BSString.recipesPath().path + (fileName as String)), options: [.atomic])
            
            print(jsonString)
            isCreated = true
            
        } catch _ {
            print("ERROR")
            isCreated = false
        }
        
        // Empty dictionaries
        if (isCreated) {
            fermentList.removeAllObjects()
            hopList.removeAllObjects()
            yeastList.removeAllObjects()
        }
        
        return isCreated
    }
    
    // end region //
    
    // #pragma mark - list functions
    func clearFermentables() {
        if (fermentList.count > 0) {
            fermentList = []
        }
    }
    
    func clearHops() {
        if (hopList.count > 0) {
            hopList = []
        }
    }
    
    func clearYeasts() {
        if (yeastList.count > 0) {
            yeastList = []
        }
    }
    
    // end region //
    
    // #pragma mark - Conversion functions
    func convertLitersToGallons(_ liters: Float) -> Float {
        let gallons: Float = liters / 3.78541
        return gallons
    }
    
    func convertGramsToOunces(_ grams: Float) -> Float {
        let ounces: Float = grams / 28.3459
        return ounces
    }
    
    func convertKiloToPounds(_ kilos: Float) -> Float {
        let pounds: Float = kilos / 0.453592
        return pounds
    }
    
    func convertGallonsToLiters(_ gallons: Float) -> Float {
        let liters: Float = gallons * 3.78541
        return liters
    }
    
    func convertOuncesToGrams(_ ounces: Float) -> Float {
        let grams: Float = ounces * 28.3459
        return grams
    }
    
    func convertPoudnsToKilos(_ pounds: Float) -> Float {
        let kilos: Float = pounds * 0.453592
        return kilos
    }
    
    func convertCtempToFtemp(_ C: Float) -> Float {
        return C * 1.8 + 32
    }
    
    func convertFtempToCtemp(_ F: Float) -> Float {
        return (F - 32) / 1.8
    }
    
    // end region //
}
