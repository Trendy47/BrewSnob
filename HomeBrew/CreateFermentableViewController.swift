//
//  CreateFermentableViewController.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 3/12/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation
import UIKit

class CreateFermentableViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var textfieldArray: [UITextField]!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var ppgTextField: UITextField!
    @IBOutlet weak var LTextField: UITextField!
    @IBOutlet weak var usageTextField: UITextField!
    
    @IBOutlet weak var weightUnitLabel: UILabel!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    
    var fermentable: NSDictionary!
    let pickerOptions = ["Mash", "Extract", "Steep", "Late"]
    var isEditingFermentable: Bool = false
    
    // #pragma mark - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let themeColor = UIColor(netHex: BSColor.brewSnobBlack())
        UIView.hr_setToastThemeColor(color: themeColor)
        
        applyStyle()
        
        if (fermentable != nil) {
            loadViewWithObject()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateFermentableViewController.didTapOnScreen(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        self.usageTextField.inputView = pickerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func loadViewWithObject() {
        self.isEditingFermentable = true
        self.createButton.setTitle("Save", for: UIControlState())
        
        let weight: Float = (self.fermentable.object(forKey: "weight") as? Float)!
        let ppg: Int = (self.fermentable.object(forKey: "ppg") as? Int)!
        let lovibond: Int = (self.fermentable.object(forKey: "L") as? Int)!
        
        self.nameTextField.text = self.fermentable.object(forKey: "name") as? String
        self.weightTextField.text = "\(weight)"
        self.ppgTextField.text = "\(ppg)"
        self.LTextField.text = "\(lovibond)"
        self.usageTextField.text = self.fermentable.object(forKey: "usage") as? String
        
        let unit: String = (fermentable.object(forKey: "unit") as! String)
        if (unit == "US") {
            self.unitSegmentedControl.selectedSegmentIndex = 0
            weightUnitLabel.text = "(lb)"
        } else {
            self.unitSegmentedControl.selectedSegmentIndex = 1
            weightUnitLabel.text = "(kg)"
        }
    }
    
    // #pragma mark - IBActions
    @IBAction func didTapCloseBtn(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapCreateBtn(_ sender: AnyObject) {
        var index = -1
        if (isEditingFermentable)
        {
            let repo = FermentableObject.sharedInstance.fermentables
            index = repo.index(of: self.fermentable)
            repo.remove(self.fermentable)
        }
        
        let name: String? = self.nameTextField.text
        let weight: Float = (self.weightTextField.text?.floatValue)!
        let ppg: Float = (self.ppgTextField.text?.floatValue)!
        let L: Float = (self.LTextField.text?.floatValue)!
        let usage: String? = self.usageTextField.text
        let unit: String? = (self.unitSegmentedControl.selectedSegmentIndex == 0 ? "US" : "Metric")
        
        let fermentDict: NSMutableDictionary = NSMutableDictionary()
        fermentDict.setValue(unit, forKey: "unit")
        fermentDict.setValue(name, forKey: "name")
        fermentDict.setValue(weight, forKey: "weight")
        fermentDict.setValue(ppg, forKey: "ppg")
        fermentDict.setValue(L, forKey: "L")
        fermentDict.setValue(usage, forKey: "usage")
        
        FermentableObject.sharedInstance.createObject(fermentDict, index: index)
        self.view.makeToast(message: "Fermentable Created", duration: 2, position: HRToastPositionCenter as AnyObject)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didChangeUnitType(_ sender: UISegmentedControl) {
        let weight:Float = (weightTextField.text?.floatValue)!
        
        if (sender.selectedSegmentIndex == 0) {
            // US
            let newWeight:Float = weight / 0.453592
            self.weightTextField.text = NSString(format: "%.2f", newWeight) as String
            
            UIView.animate(withDuration: 1.0, animations:{
                self.weightUnitLabel.alpha = 0.0
                self.weightUnitLabel.text = "(lb)"
                self.weightUnitLabel.alpha = 1.0
            })
        }
        
        if (sender.selectedSegmentIndex == 1) {
            // Metric
            let newWeight:Float = weight * 0.453592
            self.weightTextField.text = NSString(format: "%.2f", newWeight) as String
            
            UIView.animate(withDuration: 1.0, animations:{
                self.weightUnitLabel.alpha = 0.0
                self.weightUnitLabel.text = "(kg)"
                self.weightUnitLabel.alpha = 1.0
            })
        }
    }
    
    // #pragma mark - Private
    func applyStyle() {
        self.view.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
        self.topView.backgroundColor = UIColor(netHex: BSColor.brewSnobGreen())
        self.unitSegmentedControl.tintColor = UIColor(netHex: BSColor.brewSnobMintGreen())
        
        for textField in textfieldArray {
            textField.backgroundColor = UIColor(netHex: BSColor.brewSnobGrey()) //7fb27f
            textField.layer.cornerRadius = 2.0
        }
    }
    
    @objc func didTapOnScreen(_ gesture: UITapGestureRecognizer) {
        for textField in textfieldArray {
            textField.resignFirstResponder()
        }
    }
    
    // #pragma mark - UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.usageTextField.text = pickerOptions[row]
        pickerView.resignFirstResponder()
    }
}
