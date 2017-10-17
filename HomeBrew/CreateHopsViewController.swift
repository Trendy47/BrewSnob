//
//  CreateHopsViewController.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 3/16/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation
import UIKit

class CreateHopsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var textfieldArray: [UITextField]!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var varietyTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var aaTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var usageTextField: UITextField!
    
    @IBOutlet weak var weightUnitLabel: UILabel!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    
    var hop: NSDictionary!
    let typePickerOptions = ["Leaf", "Pellet", "Plug"]
    let usagePickerOptions = ["First Wort", "Mash", "Boil", "Flame Out", "Dry Hop"]
    
    var isMetric: Bool = false
    var isEditingHops: Bool = false
    
    // #pragma mark - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let themeColor = UIColor(netHex: BSColor.brewSnobBlack())
        UIView.hr_setToastThemeColor(color: themeColor)
        
        applyStyle()
        
        if (hop != nil) {
            loadViewWithObject()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateHopsViewController.didTapOnScreen(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        self.usageTextField.inputView = pickerView
        self.typeTextField.inputView = pickerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func loadViewWithObject() {
        self.isEditingHops = true
        self.createButton.setTitle("Save", for: UIControlState())
        
        let weight: Float = (self.hop.object(forKey: "weight") as? Float)!
        let aa: Float = (self.hop.object(forKey: "aa") as? Float)!
        let time: Int = (self.hop.object(forKey: "time") as? Int)!
        
        self.varietyTextField.text = self.hop.object(forKey: "variety") as? String
        self.weightTextField.text = "\(weight)"
        self.aaTextField.text = "\(aa)"
        self.typeTextField.text = self.hop.object(forKey: "type") as? String
        self.timeTextField.text = "\(time)"
        self.usageTextField.text = self.hop.object(forKey: "usage") as? String
        
        let unit: String = (hop.object(forKey: "unit") as! String)
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
        if (self.isEditingHops) {
            let repo = RecipeManager.sharedInstance.hopList
            index = repo.index(of: self.hop)
            repo.remove(self.hop)
        }
        
        let variety: String? = self.varietyTextField.text
        let weight: Float = (self.weightTextField.text?.floatValue)!
        let aa: Float = (self.aaTextField.text?.floatValue)!
        let type: String? = self.typeTextField.text
        let time: Float = (self.timeTextField.text?.floatValue)!
        let usage: String? = self.usageTextField.text
        let unit: String? = (self.unitSegmentedControl.selectedSegmentIndex == 0 ? "US" : "Metric")
        
        let repo = RecipeManager.sharedInstance
        repo.calculateSpecifications()
        let ibu: Float = repo.calculateBitterness(aa, weight: weight, time: time, unit: unit!, type: type!)
        
        let hopDict: NSMutableDictionary = NSMutableDictionary()
        hopDict.setValue(unit, forKey: "unit")
        hopDict.setValue(variety, forKey: "variety")
        hopDict.setValue(weight, forKey: "weight")
        hopDict.setValue(aa, forKey: "aa")
        hopDict.setValue(ibu, forKey: "ibu")
        hopDict.setValue(type, forKey: "type")
        hopDict.setValue(time, forKey: "time")
        hopDict.setValue(usage, forKey: "usage")
        
        RecipeManager.sharedInstance.hopList.insert(HopsObject(hopDict), at: index)
        self.view.makeToast(message: "Hop Created", duration: 2, position: HRToastPositionCenter as AnyObject)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didChangeUnitType(_ sender: UISegmentedControl) {
        let weight:Float = (weightTextField.text?.floatValue)!
        
        if (sender.selectedSegmentIndex == 0) {
            // US
            isMetric = false
            
            let newWeight:Float = weight / 28.3495
            self.weightTextField.text = NSString(format: "%.1f", newWeight) as String
            
            UIView.animate(withDuration: 1.0, animations:{
                self.weightUnitLabel.alpha = 0.0
                self.weightUnitLabel.text = "(oz)"
                self.weightUnitLabel.alpha = 1.0
            })
        }
        
        if (sender.selectedSegmentIndex == 1) {
            // Metric
            isMetric = true
            
            let newWeight:Float = weight * 28.3495
            self.weightTextField.text = NSString(format: "%.1f", newWeight) as String
            
            UIView.animate(withDuration: 1.0, animations:{
                self.weightUnitLabel.alpha = 0.0
                self.weightUnitLabel.text = "(g)"
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
        if (self.usageTextField.isFirstResponder) {
            return usagePickerOptions.count
        }
        else if (self.typeTextField.isFirstResponder) {
            return typePickerOptions.count
        }
        else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (self.usageTextField.isFirstResponder) {
            return usagePickerOptions[row]
        }
        else if (self.typeTextField.isFirstResponder) {
            return typePickerOptions[row]
        }
        else {
            return "Null"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (self.usageTextField.isFirstResponder) {
            self.usageTextField.text = usagePickerOptions[row]
        }
        
        if (self.typeTextField.isFirstResponder) {
            self.typeTextField.text = typePickerOptions[row]
        }
        
        pickerView.resignFirstResponder()
    }
}
