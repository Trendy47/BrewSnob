//
//  IBUViewController.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 10/11/15.
//  Copyright © 2015 Chris Tirendi. All rights reserved.
//

import Foundation
import UIKit

class IBUViewController : UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet var viewArray: [UIView]!
    @IBOutlet var switchArray: [UISwitch]!
    @IBOutlet var textFieldArray: [UITextField]!
    
    @IBOutlet weak var finalVolumeLabel: UILabel!
    @IBOutlet weak var hopWeightLabel: UILabel!
    
    @IBOutlet weak var sgTextField: UITextField!
    @IBOutlet weak var fvTextField: UITextField!
    
    @IBOutlet weak var hopTwoSwitch: UISwitch!
    @IBOutlet weak var hopThreeSwitch: UISwitch!
    @IBOutlet weak var hopFourSwitch: UISwitch!
    @IBOutlet weak var hopFiveSwitch: UISwitch!
    
    @IBOutlet weak var aaOneTextField: UITextField!
    @IBOutlet weak var aaTwoTextField: UITextField!
    @IBOutlet weak var aaThreeTextField: UITextField!
    @IBOutlet weak var aaFourTextField: UITextField!
    @IBOutlet weak var aaFiveTextField: UITextField!
    
    @IBOutlet weak var maOneTextField: UITextField!
    @IBOutlet weak var maTwoTextField: UITextField!
    @IBOutlet weak var maThreeTextField: UITextField!
    @IBOutlet weak var maFourTextField: UITextField!
    @IBOutlet weak var maFiveTextField: UITextField!
    
    @IBOutlet weak var tbOneTextField: UITextField!
    @IBOutlet weak var btTwoTextField: UITextField!
    @IBOutlet weak var btThreeTextField: UITextField!
    @IBOutlet weak var btFourTextField: UITextField!
    @IBOutlet weak var btFiveTextField: UITextField!
    
    @IBOutlet weak var ibuTextField: UITextField!
    @IBOutlet weak var calculateBtn: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    
    let COEFF1: Float = 1.65
    let COEFF2: Float = 1.25e-4
    let COEFF3: Float = 0.04
    let COEFF4: Float = 4.15
    let GRAMSPEROUNCE: Float = 28.3
    let LITERSPERGALLON: Float = 3.785
    let GRAMSPERKG: Float = 1000.0
    
    var isMetric: Bool = false
    
    let customObject = RecipeManager.sharedInstance
    
    // #pragma mark - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(IBUViewController.didTapOnScreen(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(IBUViewController.goBack(_:)))
        swipeGesture.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func didTapOnScreen(_ gesture: UITapGestureRecognizer) {
        for textField in textFieldArray {
            textField.resignFirstResponder()
        }
    }
    
    @objc func goBack(_ gesture: UISwipeGestureRecognizer) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // #pragma mark - IBActions
    @IBAction func didTapBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapCalculate(_ sender: AnyObject) {
        (sender as! UIView).shake()
        calculateIBU()
    }
    
    @IBAction func didTapSwitch(_ sender: AnyObject) {
        
    }
    
    @IBAction func didChangeSegmentedControl(_ sender: UISegmentedControl) {
        
        if (sender.selectedSegmentIndex == 0) {
            isMetric = false
            
            UIView.animate(withDuration: 1.0, animations:{
                self.finalVolumeLabel.alpha = 0.0
                self.finalVolumeLabel.text = "(Gallons)"
                self.finalVolumeLabel.alpha = 1.0
            })
            
            UIView.animate(withDuration: 1.0, animations:{
                self.hopWeightLabel.alpha = 0.0
                self.hopWeightLabel.text = "(oz)"
                self.hopWeightLabel.alpha = 1.0
            })
            
            // convert to gallons
            let convertL = customObject.convertLitersToGallons((self.fvTextField.text?.floatValue)!)
            self.fvTextField.text = "\(convertL)"
        }
        
        if (sender.selectedSegmentIndex == 1) {
            isMetric = true
            
            UIView.animate(withDuration: 1.0, animations:{
                self.finalVolumeLabel.alpha = 0.0
                self.finalVolumeLabel.text = "(Liters)"
                self.finalVolumeLabel.alpha = 1.0
            })
            
            UIView.animate(withDuration: 1.0, animations:{
                self.hopWeightLabel.alpha = 0.0
                self.hopWeightLabel.text = "(gram)"
                self.hopWeightLabel.alpha = 1.0
            })
            
            // convert to liters
            let convertG = customObject.convertGallonsToLiters((self.fvTextField.text?.floatValue)!)
            self.fvTextField.text = "\(convertG)"
        }
        
        converthopWeight(isMetric)
        calculateIBU()
    }
    
    // #pragma mark - Private
    func calculateIBU() {
        
        let aaOne: Float = (aaOneTextField.text?.floatValue)!
        let aaTwo: Float = (aaTwoTextField.text?.floatValue)!
        let aaThree: Float = (aaThreeTextField.text?.floatValue)!
        let aaFour: Float = (aaFourTextField.text?.floatValue)!
        let aaFive: Float = (aaFiveTextField.text?.floatValue)!
        
        let maOne: Float = (maOneTextField.text?.floatValue)!
        let maTwo: Float = (maTwoTextField.text?.floatValue)!
        let maThree: Float = (maThreeTextField.text?.floatValue)!
        let maFour: Float = (maFourTextField.text?.floatValue)!
        let maFive: Float = (maFiveTextField.text?.floatValue)!
        
        let btOne: Float = (tbOneTextField.text?.floatValue)!
        let btTwo: Float = (btTwoTextField.text?.floatValue)!
        let btThree: Float = (btThreeTextField.text?.floatValue)!
        let btFour: Float = (btFourTextField.text?.floatValue)!
        let btFive: Float = (btFiveTextField.text?.floatValue)!
        
        var ibu1: Float = 0
        var ibu2: Float = 0
        var ibu3: Float = 0
        var ibu4: Float = 0
        var ibu5: Float = 0
        var totalIbu: Float = 0
        
        // Probably not the cleaest way to do this
        // if two hop swithces are on - calculaute the ibu for each hop,
        // then add the two ibus together to get the total ibu
        // same goes for three, four, and five
        
        if hopTwoSwitch.isOn && !hopThreeSwitch.isOn && !hopFourSwitch.isOn && !hopFiveSwitch.isOn {
            let weight = maOne
            let alpha = aaOne / 100
            let time = btOne
            
            ibu1 = calculateBitterness(alpha, weight: weight, time: time)
            
            let weight2 = maTwo
            let alpha2 = aaTwo / 100
            let time2 = btTwo
            
            ibu2 = calculateBitterness(alpha2, weight: weight2, time: time2)
            
            totalIbu = ibu1 + ibu2
        }
        
        if hopTwoSwitch.isOn && hopThreeSwitch.isOn && !hopFourSwitch.isOn && !hopFiveSwitch.isOn {
            let weight = maThree
            let alpha = aaThree / 100
            let time = btThree
            
            ibu1 = calculateBitterness(alpha, weight: weight, time: time)
            
            let weight2 = maTwo
            let alpha2 = aaTwo / 100
            let time2 = btTwo
            
            ibu2 = calculateBitterness(alpha2, weight: weight2, time: time2)
            
            let weight3 = maTwo
            let alpha3 = aaTwo / 100
            let time3 = btTwo
            
            ibu3 *= calculateBitterness(alpha3, weight: weight3, time: time3)
            
            totalIbu = ibu1 + ibu2 + ibu3
        }
        
        if hopTwoSwitch.isOn && hopThreeSwitch.isOn && hopFourSwitch.isOn && !hopFiveSwitch.isOn {
            let weight = maFour
            let alpha = aaFour / 100
            let time = btFour
            
            ibu1 = calculateBitterness(alpha, weight: weight, time: time)
            
            let weight2 = maTwo
            let alpha2 = aaTwo / 100
            let time2 = btTwo
            
            ibu2 = calculateBitterness(alpha2, weight: weight2, time: time2)
            
            let weight3 = maTwo
            let alpha3 = aaTwo / 100
            let time3 = btTwo
            
            ibu3 = calculateBitterness(alpha3, weight: weight3, time: time3)
            
            let weight4 = maTwo
            let alpha4 = aaTwo / 100
            let time4 = btTwo
            
            ibu5 = calculateBitterness(alpha4, weight: weight4, time: time4)
            
            totalIbu = ibu1 + ibu2 + ibu3 + ibu4
        }
        
        if hopTwoSwitch.isOn && hopThreeSwitch.isOn && hopFourSwitch.isOn && hopFiveSwitch.isOn {
            let weight = maFive
            let alpha = aaFive / 100
            let time = btFive
            
            ibu1 = calculateBitterness(alpha, weight: weight, time: time)
            
            let weight2 = maFour
            let alpha2 = aaFour / 100
            let time2 = btFour
            
            ibu2 = calculateBitterness(alpha2, weight: weight2, time: time2)
            
            let weight3 = maTwo
            let alpha3 = aaTwo / 100
            let time3 = btTwo
            
            ibu3 = calculateBitterness(alpha3, weight: weight3, time: time3)
            
            let weight4 = maTwo
            let alpha4 = aaTwo / 100
            let time4 = btTwo
            
            ibu4 = calculateBitterness(alpha4, weight: weight4, time: time4)
            
            let weight5 = maTwo
            let alpha5 = aaTwo / 100
            let time5 = btTwo
            
            ibu5 = calculateBitterness(alpha5, weight: weight5, time: time5)
            
            totalIbu = ibu1 + ibu2 + ibu3 + ibu4 + ibu5
        }
        
        if !hopTwoSwitch.isOn && !hopThreeSwitch.isOn && !hopFourSwitch.isOn && !hopFiveSwitch.isOn {
            let weight = maOne
            let alpha = aaOne / 100
            let time = btOne
            
            totalIbu = calculateBitterness(alpha, weight: weight, time: time)
        }
        
        self.ibuTextField.text = String(format: "%.2f %", totalIbu)
    }
    
    func calculateBitterness(_ alpha: Float, weight: Float, time: Float) -> Float {
        let sg: Float = (sgTextField.text?.floatValue)!
        let fv: Float = (fvTextField.text?.floatValue)!
        //let bt: Float = 0 Add field to view maybe?
        var bitterness: Float = 0
        
        if (isMetric) {
            let x = COEFF1 * pow(COEFF2, (fabs(sg)-1.0))
            let y = (1.0-exp(-COEFF3*fabs(time)))
            let z = fabs(alpha) * fabs(weight) * GRAMSPERKG / (fabs(fv) * COEFF4)
            bitterness = x * y * z
        } else {
            let x = COEFF1 * pow(COEFF2, (fabs(sg)-1.0))
            let y = (1.0-exp(-COEFF3*fabs(time)))
            let z = fabs(alpha) * fabs(weight) * GRAMSPEROUNCE * GRAMSPERKG / (LITERSPERGALLON * fabs(fv) * COEFF4)
            bitterness = x * y * z
        }
        
        /* Maybe use this formula instead?
        * let gravity: Float = (fv / bt) * (sg - 1)
        * let bignessFactor: Float = 1.65 * pow(0.000125, gravity)
        * let boilTimeFactor: Float = (1 - pow(2.718281828459045235, (-0.04 * time))) / 4.15
        * let utilization: Float = bignessFactor * boilTimeFactor
        
        * bitterness = (alpha * weight) * utilization * 74.90 / fv
        */
        
        return bitterness
    }
    
    func converthopWeight(_ isMetric: Bool) {
        
        if isMetric {
         
            let convertHWOne = customObject.convertOuncesToGrams((self.maOneTextField.text?.floatValue)!)
            self.maOneTextField.text = "\(convertHWOne)"
            
            if hopTwoSwitch.isOn && !hopThreeSwitch.isOn && !hopFourSwitch.isOn && !hopFiveSwitch.isOn {
                let convertHWTwo = customObject.convertOuncesToGrams((self.maTwoTextField.text?.floatValue)!)
                self.maTwoTextField.text = "\(convertHWTwo)"
            }
            
            if hopTwoSwitch.isOn && hopThreeSwitch.isOn && !hopFourSwitch.isOn && !hopFiveSwitch.isOn {
                let convertHWTwo = customObject.convertOuncesToGrams((self.maTwoTextField.text?.floatValue)!)
                self.maTwoTextField.text = "\(convertHWTwo)"

                let convertHWThree = customObject.convertOuncesToGrams((self.maThreeTextField.text?.floatValue)!)
                self.maThreeTextField.text = "\(convertHWThree)"
            }
            
            if hopTwoSwitch.isOn && hopThreeSwitch.isOn && hopFourSwitch.isOn && !hopFiveSwitch.isOn {
                let convertHWTwo = customObject.convertOuncesToGrams((self.maTwoTextField.text?.floatValue)!)
                self.maTwoTextField.text = "\(convertHWTwo)"
                
                let convertHWThree = customObject.convertOuncesToGrams((self.maThreeTextField.text?.floatValue)!)
                self.maThreeTextField.text = "\(convertHWThree)"
                
                let convertHWFour = customObject.convertOuncesToGrams((self.maFourTextField.text?.floatValue)!)
                self.maFourTextField.text = "\(convertHWFour)"
            }
            
            if hopTwoSwitch.isOn && hopThreeSwitch.isOn && hopFourSwitch.isOn && hopFiveSwitch.isOn {
                let convertHWTwo = customObject.convertOuncesToGrams((self.maTwoTextField.text?.floatValue)!)
                self.maTwoTextField.text = "\(convertHWTwo)"
                
                let convertHWThree = customObject.convertOuncesToGrams((self.maThreeTextField.text?.floatValue)!)
                self.maThreeTextField.text = "\(convertHWThree)"
                
                let convertHWFour = customObject.convertOuncesToGrams((self.maFourTextField.text?.floatValue)!)
                self.maFourTextField.text = "\(convertHWFour)"
                
                let convertHWFive = customObject.convertOuncesToGrams((self.maFiveTextField.text?.floatValue)!)
                self.maFiveTextField.text = "\(convertHWFive)"
            }
            
            
        } else {
            
            let convertHWOne = customObject.convertGramsToOunces((self.maOneTextField.text?.floatValue)!)
            self.maOneTextField.text = "\(convertHWOne)"
            
            if hopTwoSwitch.isOn && !hopThreeSwitch.isOn && !hopFourSwitch.isOn && !hopFiveSwitch.isOn {
                let convertHWTwo = customObject.convertGramsToOunces((self.maTwoTextField.text?.floatValue)!)
                self.maTwoTextField.text = "\(convertHWTwo)"
            }
            
            if hopTwoSwitch.isOn && hopThreeSwitch.isOn && !hopFourSwitch.isOn && !hopFiveSwitch.isOn {
                let convertHWTwo = customObject.convertGramsToOunces((self.maTwoTextField.text?.floatValue)!)
                self.maTwoTextField.text = "\(convertHWTwo)"
                
                let convertHWThree = customObject.convertGramsToOunces((self.maThreeTextField.text?.floatValue)!)
                self.maThreeTextField.text = "\(convertHWThree)"
            }
            
            if hopTwoSwitch.isOn && hopThreeSwitch.isOn && hopFourSwitch.isOn && !hopFiveSwitch.isOn {
                let convertHWTwo = customObject.convertGramsToOunces((self.maTwoTextField.text?.floatValue)!)
                self.maTwoTextField.text = "\(convertHWTwo)"
                
                let convertHWThree = customObject.convertGramsToOunces((self.maThreeTextField.text?.floatValue)!)
                self.maThreeTextField.text = "\(convertHWThree)"
                
                let convertHWFour = customObject.convertGramsToOunces((self.maFourTextField.text?.floatValue)!)
                self.maFourTextField.text = "\(convertHWFour)"
            }
            
            if hopTwoSwitch.isOn && hopThreeSwitch.isOn && hopFourSwitch.isOn && hopFiveSwitch.isOn {
                let convertHWTwo = customObject.convertGramsToOunces((self.maTwoTextField.text?.floatValue)!)
                self.maTwoTextField.text = "\(convertHWTwo)"
                
                let convertHWThree = customObject.convertGramsToOunces((self.maThreeTextField.text?.floatValue)!)
                self.maThreeTextField.text = "\(convertHWThree)"
                
                let convertHWFour = customObject.convertGramsToOunces((self.maFourTextField.text?.floatValue)!)
                self.maFourTextField.text = "\(convertHWFour)"
                
                let convertHWFive = customObject.convertGramsToOunces((self.maFiveTextField.text?.floatValue)!)
                self.maFiveTextField.text = "\(convertHWFive)"
            }
        }
    }
    
    func applyStyle() {
        self.view.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
        self.topView.backgroundColor = UIColor(netHex: BSColor.brewSnobGreen())
        
        self.calculateBtn.layer.cornerRadius = 2.0
        self.calculateBtn.backgroundColor = UIColor(netHex: BSColor.brewSnobBrown())
        
        self.unitSegmentedControl.tintColor = UIColor(netHex: BSColor.brewSnobMintGreen())
        
        for view in viewArray {
            view.layer.cornerRadius = 2.0
            view.layer.masksToBounds = true
            view.backgroundColor = UIColor(netHex: BSColor.brewSnobGreen())
        }
        
        for hops in switchArray {
            hops.onTintColor = UIColor(netHex: BSColor.brewSnobBrown())
            hops.tintColor = UIColor.white
        }
        
        for textField in textFieldArray {
            textField.layer.cornerRadius = 2.0
            textField.backgroundColor = UIColor(netHex: BSColor.brewSnobGrey())
        }
    }
}
