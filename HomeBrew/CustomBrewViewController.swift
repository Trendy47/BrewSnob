//
//  CustomBrewViewController.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 11/1/15.
//  Copyright © 2015 Chris Tirendi. All rights reserved.
//

import Foundation
import UIKit

class CustomBrewViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var textViewArray: [UITextView]!
    @IBOutlet var textFieldArray: [UITextField]!
    @IBOutlet var toolBarButtonArray: [UIButton]!
    @IBOutlet var buttonArray: [UIButton]!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var brewNameTextField: UITextField!
    @IBOutlet weak var receipeTypeTextField: UITextField!
    @IBOutlet weak var batchSizeTextField: UITextField!
    @IBOutlet weak var boilSizeTextField: UITextField!
    @IBOutlet weak var boilTimeTextField: UITextField!
    @IBOutlet weak var efficiencyTextField: UITextField!
    @IBOutlet weak var iTextView: UITextView!
    @IBOutlet weak var dTextView: UITextView!
    
    @IBOutlet weak var createBrewButton: UIButton!
    @IBOutlet weak var addFermentsButton: UIButton!
    @IBOutlet weak var addHopsButton: UIButton!
    @IBOutlet weak var addYeastButton: UIButton!
    @IBOutlet weak var viewIngredientsButton: UIButton!
    
    @IBOutlet weak var fermentCountLabel: UILabel!
    @IBOutlet weak var hopCountLabel: UILabel!
    @IBOutlet weak var yeastCountLabel: UILabel!
    
    @IBOutlet weak var unitSegmentControl: UISegmentedControl!
    @IBOutlet weak var viewSpecsBtn: UIButton!
    @IBOutlet weak var specificationsView: UIView!
    @IBOutlet weak var specBatchSizeLabel: UILabel!
    @IBOutlet weak var specBoilSizeLabel: UILabel!
    @IBOutlet weak var specOriginalGravLabel: UILabel!
    @IBOutlet weak var specFinalGravLabel: UILabel!
    @IBOutlet weak var specSRMLabel: UILabel!
    @IBOutlet weak var specIBULabel: UILabel!
    @IBOutlet weak var specABVLabel: UILabel!
    
    @IBOutlet weak var batchUnitLabel: UILabel!
    @IBOutlet weak var boilUnitLabel: UILabel!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var originalGravity: Float = 0
    var finalGravity: Float = 0
    var batchSize: Float = 0
    var boilSize: Float = 0
    var boilTime: Float = 0
    var efficiency: Float = 0
    var abv: Float = 0
    var ibu: Float = 0
    var srm: Float = 0
    var unit: String = "US"
    
    var isMetric: Bool = false
    
    let customBrew = RecipeManager.sharedInstance
    var editBeer:Beer!
    
    var dTextViewClicked: Bool = false
    
    // #pragma mark - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let themeColor = UIColor(netHex: BSColor.brewSnobBlack())
        UIView.hr_setToastThemeColor(color: themeColor)
        
        // Clear arrays on load
        RecipeManager.sharedInstance.clearFermentables()
        RecipeManager.sharedInstance.clearHops()
        RecipeManager.sharedInstance.clearYeasts()
        
        applyStyle()
        updateButtonText()
        
        if (self.editBeer != nil) {
            loadEditableBeer()
        }
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
        
        self.brewNameTextField.delegate = self
        self.receipeTypeTextField.delegate = self
        self.batchSizeTextField.delegate = self
        self.boilSizeTextField.delegate = self
        self.boilTimeTextField.delegate = self
        self.efficiencyTextField.delegate = self
        
        self.iTextView.delegate = self
        self.dTextView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomBrewViewController.didTapOnScreen(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(CustomBrewViewController.goBack(_:)))
        swipeGesture.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CustomBrewViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(CustomBrewViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateButtonText()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func loadEditableBeer() {
        /* Parse beer json file */
        
        // Start with simple variables
        self.brewNameTextField.text = self.editBeer.beerName
        self.receipeTypeTextField.text = self.editBeer.recipeType
        self.batchSizeTextField.text = self.editBeer.batchSize
        self.boilSizeTextField.text = self.editBeer.boilSize
        self.boilTimeTextField.text = self.editBeer.boilTime
        self.efficiencyTextField.text = self.editBeer.efficiency
        
        // set custom brew object variables
        self.customBrew.brewName = self.brewNameTextField.text
        self.customBrew.recipeType = self.receipeTypeTextField.text
        self.customBrew.batchSize = (self.batchSizeTextField.text?.floatValue)!
        self.customBrew.boilSize = (self.boilSizeTextField.text?.floatValue)!
        self.customBrew.boilTime = (self.boilTimeTextField.text?.floatValue)!
        self.customBrew.efficiency = (self.efficiencyTextField.text?.floatValue)!
        
        // parse fermentable string into fermentable object
        var fIndex = 0
        let fObjects = self.editBeer.fermentables.components(separatedBy: "\n")
        for ferment in fObjects {
            if (ferment == "") { continue }
            
            let components = ferment.components(separatedBy: " / ")
            let weightunit = components[0].components(separatedBy: " of ")[0]
            let weight: Float = (weightunit.components(separatedBy: " ")[0].floatValue)
            let unit: String? = weightunit.components(separatedBy: " ")[1]
            let name: String? = components[0].components(separatedBy: " lb of ")[1]
            let ppg: Float = (components[1].components(separatedBy: " ppg")[0].floatValue)
            let lovi: Float = (components[2].components(separatedBy: " L°")[0].floatValue)
            let usage: String? = components[3]
            
            let fermentDict: NSMutableDictionary = NSMutableDictionary()
            fermentDict.setValue((unit == "lb" ? "US" : "Metric"), forKey: "unit")
            fermentDict.setValue(name, forKey: "name")
            fermentDict.setValue(weight, forKey: "weight")
            fermentDict.setValue(ppg, forKey: "ppg")
            fermentDict.setValue(lovi, forKey: "L")
            fermentDict.setValue(usage, forKey: "usage")
            
            RecipeManager.sharedInstance.fermentList.insert(FermentableObject(fermentDict), at: fIndex)
            fIndex += 1
        }
        
        // hops
        var hIndex = 0
        let hObjects = self.editBeer.hops.components(separatedBy: "\n")
        for hop in hObjects {
            if (hop == "") { continue }
            
            let components = hop.components(separatedBy: " / ")
            let weightunit = components[0].components(separatedBy: " of ")[0]
            let weight: Float = (weightunit.components(separatedBy: " ")[0].floatValue)
            let unit: String? = weightunit.components(separatedBy: " ")[1]
            let name: String? = components[0].components(separatedBy: " of ")[1]
            let type: String? = components[1]
            let usage: String? = components[2].components(separatedBy: " @ ")[0]
            
            let time: Float = (components[2].components(separatedBy: " @ ")[1].components(separatedBy: " min")[0].floatValue)
            
            let aa: Float = (components[3].components(separatedBy: " AA")[0].floatValue)
            let ibu: Float = (components[4].components(separatedBy: " IBU")[0].floatValue)
            
            let hopDict: NSMutableDictionary = NSMutableDictionary()
            hopDict.setValue((unit == "lb" ? "US" : "Metric"), forKey: "unit")
            hopDict.setValue(name, forKey: "variety")
            hopDict.setValue(weight, forKey: "weight")
            hopDict.setValue(aa, forKey: "aa")
            hopDict.setValue(ibu, forKey: "ibu")
            hopDict.setValue(type, forKey: "type")
            hopDict.setValue(time, forKey: "time")
            hopDict.setValue(usage, forKey: "usage")
            
            RecipeManager.sharedInstance.hopList.insert(HopsObject(hopDict), at: hIndex)
            hIndex += 1
        }
        
        // yeast
        var yIndex = 0
        let yObjects = self.editBeer.yeasts.components(separatedBy: "\n")
        for yeast in yObjects {
            if (yeast == "") { continue }
            
            let name: String? = yeast.components(separatedBy: " with ")[0]
            let attenuation: Float = (yeast.components(separatedBy: " with ")[1].floatValue)
            
            let yeastDict: NSMutableDictionary = NSMutableDictionary()
            yeastDict.setValue(name, forKey: "name")
            yeastDict.setValue(attenuation, forKey: "attenuation")
            
            RecipeManager.sharedInstance.yeastList.insert(YeastObject(yeastDict), at: yIndex)
            yIndex += 1
        }
        
        // Finish with textviews
        self.iTextView.text = self.editBeer.ingredients
        self.dTextView.text = self.editBeer.directions
    }
    
    // #pragma mark - IBActions
    @IBAction func didTapViewIngredientsButton(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Ingredients", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "IngredientsTableViewController") as! IngredientsTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapAddFermentsBtn(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Ingredients", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateFermentableViewController") as! CreateFermentableViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func didTapAddHopsBtn(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Ingredients", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateHopsViewController") as! CreateHopsViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func didTapAddYeastBtn(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Ingredients", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateYeastViewController") as! CreateYeastViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func didChangeUnitSegmentControl(_ sender: UISegmentedControl) {
        let repo = RecipeManager.sharedInstance
        let batchText = (self.batchSizeTextField.text?.floatValue)!
        let boilText = (self.boilSizeTextField.text?.floatValue)!
        
        if (sender.selectedSegmentIndex == 0) {
            self.isMetric = false
            self.unit = "US"
            
            // liters to gallons
            let batchGal: Float = batchText / 3.78541
            self.batchSizeTextField.text = String(format: "%.1f", arguments: [batchGal])
            
            let boilGal: Float = boilText / 3.78541
            self.boilSizeTextField.text = String(format: "%.1f", arguments: [boilGal])
            
            UIView.animate(withDuration: 1.0, animations:{
                self.batchUnitLabel.alpha = 0.0
                self.batchUnitLabel.text = "(gal)"
                self.batchUnitLabel.alpha = 1.0
            })
            
            UIView.animate(withDuration: 1.0, animations:{
                self.boilUnitLabel.alpha = 0.0
                self.boilUnitLabel.text = "(gal)"
                self.boilUnitLabel.alpha = 1.0
            })
        }
        
        if (sender.selectedSegmentIndex == 1) {
            self.isMetric = true
            self.unit = "Metric"
            
            // gallons to liters
            let batchGal: Float = batchText * 3.78541
            self.batchSizeTextField.text = String(format: "%.1f", arguments: [batchGal])
            
            let boilGal: Float = boilText * 3.78541
            self.boilSizeTextField.text = String(format: "%.1f", arguments: [boilGal])
            
            UIView.animate(withDuration: 1.0, animations:{
                self.batchUnitLabel.alpha = 0.0
                self.batchUnitLabel.text = "(L)"
                self.batchUnitLabel.alpha = 1.0
            })
            
            UIView.animate(withDuration: 1.0, animations:{
                self.boilUnitLabel.alpha = 0.0
                self.boilUnitLabel.text = "(L)"
                self.boilUnitLabel.alpha = 1.0
            })
        }
        
         repo.unit = self.unit
    }
    
    @IBAction func didTapViewSpecsBtn(_ sender: AnyObject) {
        let repo = RecipeManager.sharedInstance
        repo.calculateSpecifications()
        
        var unit: String = ""
        if (isMetric) {
            unit = "Liters"
        } else {
            unit = "Gallons"
        }
        
        self.specBatchSizeLabel.text = String(format: "%.1f %@", arguments: [repo.batchSize, unit])
        self.specBoilSizeLabel.text = String(format: "%.1f %@ @ %.0f min", arguments: [repo.boilSize, unit, repo.boilTime])
        self.specOriginalGravLabel.text = String(format: "%.3f", arguments: [repo.originalGravity])
        self.specFinalGravLabel.text = String(format: "%.3f", arguments: [repo.finalGravity])
        self.specSRMLabel.text = String(format: "%.1f° SRM", arguments: [repo.finalSRM])
        self.specIBULabel.text = String(format: "%.1f IBU", arguments: [repo.finalIBU])
        self.specABVLabel.text = String(format: "%.1f ABV", arguments: [repo.finalABV])
        
        let isSpecViewVisible: Bool
        if (self.specificationsView.alpha == 0) {
            isSpecViewVisible = true
        } else {
            isSpecViewVisible = false
        }
        
        if (isSpecViewVisible) {
            UIView.animate(withDuration: 1.0, animations:{
                self.specificationsView.alpha = 1
                self.scrollView.alpha = 0
                self.viewSpecsBtn.setTitle("Go Back", for: UIControlState())
            })
        } else {
            UIView.animate(withDuration: 1.0, animations:{
                self.scrollView.alpha = 1
                self.specificationsView.alpha = 0
                self.viewSpecsBtn.setTitle("View Specifications", for: UIControlState())
            })
        }
    }
    
    @IBAction func didTapBackButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapCreateBrew(_ sender: AnyObject) {
        if ((self.brewNameTextField.text?.isEmpty) == nil) {
            self.view.makeToast(message: "Forgot to name your recipe dude.", duration: 2, position: HRToastPositionCenter as AnyObject)
            return
        }
        
        let created: Bool = RecipeManager.sharedInstance.createBeerRecipe()
        if (created) {
            self.view.makeToast(message: "Brew recipe created!", duration: 2, position: HRToastPositionCenter as AnyObject)
        } else {
            self.view.makeToast(message: "Something went wrong couldn't save the recipe, sorry bro.", duration: 4, position: HRToastPositionCenter as AnyObject)
        }
    }
    
    // #pragma mark - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.customBrew.brewName = self.brewNameTextField.text
        self.customBrew.recipeType = self.receipeTypeTextField.text
        self.customBrew.batchSize = (self.batchSizeTextField.text?.floatValue)!
        self.customBrew.boilSize = (self.boilSizeTextField.text?.floatValue)!
        self.customBrew.boilTime = (self.boilTimeTextField.text?.floatValue)!
        self.customBrew.efficiency = (self.efficiencyTextField.text?.floatValue)!
        self.customBrew.unit = self.unit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // #pragma mark - UITextViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        self.customBrew.ingredients = self.iTextView.text
        self.customBrew.directions = self.dTextView.text
    }
    
    // #pragma mark - Private
    func applyStyle() {
        self.view.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
        self.topView.backgroundColor = UIColor(netHex: BSColor.brewSnobGreen())
        self.unitSegmentControl.tintColor = UIColor(netHex: BSColor.brewSnobMintGreen())
        
        for textView in textViewArray {
            textView.layer.cornerRadius = 2.0
            textView.backgroundColor = UIColor(netHex: BSColor.brewSnobGrey())
        }
        
        for textField in textFieldArray {
            textField.backgroundColor = UIColor(netHex: BSColor.brewSnobGrey()) //7fb27f
            textField.layer.cornerRadius = 2.0
        }
        
        for button in buttonArray {
            button.layer.cornerRadius = 4.0
            button.backgroundColor = UIColor(netHex: BSColor.brewSnobMintGreen())
        }
    }
    
    func updateButtonText() {
        let fermentCount = RecipeManager.sharedInstance.fermentList.count
        let fCountStr = "Add Fermentables \(fermentCount)"
        self.fermentCountLabel.text = fCountStr
        
        let hopCount = RecipeManager.sharedInstance.hopList.count
        let hCountStr = "Add Hops \(hopCount)"
        self.hopCountLabel.text = hCountStr
        
        let yeastCount = RecipeManager.sharedInstance.yeastList.count
        let yCountStr = "Add Yeast \(yeastCount)"
        self.yeastCountLabel.text = yCountStr
    }
    
    @objc func didTapOnScreen(_ gesture: UITapGestureRecognizer) {
        for textField in textFieldArray {
            textField.resignFirstResponder()
        }
        
        for textView in textViewArray {
            textView.resignFirstResponder()
        }
    }
    
    @objc func goBack(_ gesture: UISwipeGestureRecognizer) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func adjustForKeyboard(_ notification: Notification) {
        let textview = (dTextView.isFirstResponder ? dTextView : iTextView)
        let userInfo = (notification as NSNotification).userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == NSNotification.Name.UIKeyboardWillHide {
            textview?.contentInset = UIEdgeInsets.zero
        } else {
            textview?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        textview?.scrollIndicatorInsets = self.scrollView.contentInset
        
        let selectedRange = textview?.selectedRange
        textview?.scrollRangeToVisible(selectedRange!)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        var userInfo = (notification as NSNotification).userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        self.scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
}

