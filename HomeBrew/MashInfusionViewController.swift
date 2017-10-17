//
//  MashInfusionViewController.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 3/6/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation
import UIKit

class MashInfusionViewController : UIViewController {
    
    @IBOutlet var textFieldArray: [UITextField]!
    @IBOutlet var viewArray: [UIView]!
    @IBOutlet var buttonArray: [UIButton]!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var boilWaterUSView: UIView!
    @IBOutlet weak var boilWaterMetricView: UIView!
    
    @IBOutlet weak var startTempTextField: UITextField!
    @IBOutlet weak var targetTempTextField: UITextField!
    @IBOutlet weak var grainWeightTextField: UITextField!
    @IBOutlet weak var mashThickTextField: UITextField!
    @IBOutlet weak var boilGalTextField: UITextField!
    @IBOutlet weak var boilQtTextField: UITextField!
    @IBOutlet weak var boilLTextField: UITextField!
    
    @IBOutlet weak var startTempUnitLabel: UILabel!
    @IBOutlet weak var targetTempUnitLabel: UILabel!
    @IBOutlet weak var grainWeightUnitLabel: UILabel!
    @IBOutlet weak var mashThickUnitLabel: UILabel!
    
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var unitSegmentControl: UISegmentedControl!
    
    var isMetric: Bool = false
    
    // #pragma mark - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MashInfusionViewController.didTapOnScreen(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(MashInfusionViewController.goBack(_:)))
        swipeGesture.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeGesture)
        
        applyStyle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    // #pragma mark - IBActions
    @IBAction func didTapCalculate(_ sender: AnyObject) {
        (sender as! UIView).shake()
        
        calculateMashInfusion()
    }
    
    @IBAction func didTapClear(_ sender: AnyObject) {
        (sender as! UIView).shake()
        
        for textField in textFieldArray {
            textField.text = ""
        }
    }
    
    @IBAction func didTapBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didChangeUnitType(_ sender: UISegmentedControl) {
        
        let customObject = RecipeManager.sharedInstance
        
        if (sender.selectedSegmentIndex == 0) {
            isMetric = false
            
            UIView.animate(withDuration: 1.0, animations:{
                self.boilWaterUSView.alpha = 1.0
                self.boilWaterMetricView.alpha = 0.0
            });
            
            UIView.animate(withDuration: 1.0, animations:{
                self.startTempUnitLabel.alpha = 0.0
                self.startTempUnitLabel.text = "(°F)"
                self.startTempUnitLabel.alpha = 1.0
            })
            
            UIView.animate(withDuration: 1.0, animations:{
                self.targetTempUnitLabel.alpha = 0.0
                self.targetTempUnitLabel.text = "(°F)"
                self.targetTempUnitLabel.alpha = 1.0
            })
            
            UIView.animate(withDuration: 1.0, animations:{
                self.grainWeightUnitLabel.alpha = 0.0
                self.grainWeightUnitLabel.text = "(lb)"
                self.grainWeightUnitLabel.alpha = 1.0
            })
            
            UIView.animate(withDuration: 1.0, animations:{
                self.mashThickUnitLabel.alpha = 0.0
                self.mashThickUnitLabel.text = "(qt/lb)"
                self.mashThickUnitLabel.alpha = 1.0
            })
            
            let convertGW = customObject.convertKiloToPounds((self.grainWeightTextField.text?.floatValue)!)
            let convertMT = customObject.convertKiloToPounds((self.mashThickTextField.text?.floatValue)!)
            let convertST = customObject.convertCtempToFtemp((self.startTempTextField.text?.floatValue)!)
            let convertTT = customObject.convertCtempToFtemp((self.targetTempTextField.text?.floatValue)!)
            
            self.grainWeightTextField.text = "\(convertGW)"
            self.mashThickTextField.text = "\(convertMT)"
            self.startTempTextField.text = "\(convertST)"
            self.targetTempTextField.text = "\(convertTT)"
        }
        
        if (sender.selectedSegmentIndex == 1) {
            isMetric = true
            
            UIView.animate(withDuration: 1.0, animations:{
                self.boilWaterUSView.alpha = 0.0
                self.boilWaterMetricView.alpha = 1.0
            });
            
            UIView.animate(withDuration: 1.0, animations:{
                self.startTempUnitLabel.alpha = 0.0
                self.startTempUnitLabel.text = "(°C)"
                self.startTempUnitLabel.alpha = 1.0
            })
            
            UIView.animate(withDuration: 1.0, animations:{
                self.targetTempUnitLabel.alpha = 0.0
                self.targetTempUnitLabel.text = "(°C)"
                self.targetTempUnitLabel.alpha = 1.0
            })
            
            UIView.animate(withDuration: 1.0, animations:{
                self.grainWeightUnitLabel.alpha = 0.0
                self.grainWeightUnitLabel.text = "(kg)"
                self.grainWeightUnitLabel.alpha = 1.0
            })
            
            UIView.animate(withDuration: 1.0, animations:{
                self.mashThickUnitLabel.alpha = 0.0
                self.mashThickUnitLabel.text = "(L/kg)"
                self.mashThickUnitLabel.alpha = 1.0
            })
            
            let convertGW = customObject.convertPoudnsToKilos((self.grainWeightTextField.text?.floatValue)!)
            let convertMT = customObject.convertPoudnsToKilos((self.mashThickTextField.text?.floatValue)!)
            let convertST = customObject.convertFtempToCtemp((self.startTempTextField.text?.floatValue)!)
            let convertTT = customObject.convertFtempToCtemp((self.targetTempTextField.text?.floatValue)!)
            
            self.grainWeightTextField.text = "\(convertGW)"
            self.mashThickTextField.text = "\(convertMT)"
            self.startTempTextField.text = "\(convertST)"
            self.targetTempTextField.text = "\(convertTT)"
        }
        
        calculateMashInfusion()
    }
    
    // #pragma mark - Equation Functions
    func calculateMashInfusion() {
        // Calculate Mash Infusion
        let startTemp: Float = (self.startTempTextField.text?.floatValue)! // ST
        let targetTemp: Float = (self.targetTempTextField.text?.floatValue)! // TT
        let grainWeight: Float = (self.grainWeightTextField.text?.floatValue)! // GW
        let mashThickness: Float = (self.mashThickTextField.text?.floatValue)! // MT
        let mashVolume: Float = grainWeight * mashThickness // MV
    
        // Constants
        let thermoDynamic: Float = (isMetric ? 0.41 : 0.2) // TDC
        let boilingTemp: Float = (isMetric ? 100 : 212) // BT
        
        /* Mash Infusion Equation
        * MI = (TT - ST)(TDC * GW + MV) / (BT - TT)
        */
        
        let x: Float = (targetTemp - startTemp)
        let y: Float = (thermoDynamic * grainWeight + mashVolume)
        let z: Float = (boilingTemp - targetTemp)
        
        let mashInQuarts: Float = x * y / z
        let mashInGallons: Float = mashInQuarts * 0.25
        
        if (isMetric) {
            self.boilLTextField.text = String(format: "%.2f", mashInQuarts)
        } else {
            self.boilQtTextField.text = String(format: "%.2f", mashInQuarts)
            self.boilGalTextField.text = String(format: "%.2f", mashInGallons)
        }
    }
    
    // #pragma mark - Private
    func applyStyle() {
        self.view.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
        self.topView.backgroundColor = UIColor(netHex: BSColor.brewSnobGreen())
        
        self.unitSegmentControl.tintColor = UIColor(netHex: BSColor.brewSnobMintGreen())
        
        self.calculateButton.layer.cornerRadius = 4.0
        self.calculateButton.backgroundColor = UIColor(netHex: BSColor.brewSnobBrown())
        
        self.clearButton.layer.cornerRadius = 4.0
        self.clearButton.backgroundColor = UIColor(netHex: BSColor.brewSnobBrown())
        
        for view in viewArray {
            view.layer.cornerRadius = 4.0
            view.layer.masksToBounds = true
            view.backgroundColor = UIColor(netHex: BSColor.brewSnobGreen())
        }
        
        for textField in textFieldArray {
            textField.backgroundColor = UIColor(netHex: BSColor.brewSnobGrey())
        }
    }

    @objc func didTapOnScreen(_ gesture: UITapGestureRecognizer) {
        for textField in textFieldArray {
            textField.resignFirstResponder()
        }
    }
    
    @objc func goBack(_ gesture: UISwipeGestureRecognizer) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
