//
//  MashInfusionViewController.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 11/18/15.
//  Copyright © 2015 Chris Tirendi. All rights reserved.
//

import Foundation
import UIKit

class MashWaterViewController : UIViewController {
    
    @IBOutlet var viewArray: [UIView]!
    @IBOutlet var textFieldArray: [UITextField]!
    @IBOutlet var labelArray: [UILabel]!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var bsTextField: UITextField!
    @IBOutlet weak var gaTextField: UITextField!
    @IBOutlet weak var btTextField: UITextField!
    @IBOutlet weak var tbTextField: UITextField!
    @IBOutlet weak var elTextField: UITextField!
    @IBOutlet weak var mtTextField: UITextField!
    @IBOutlet weak var gtTextField: UITextField!
    @IBOutlet weak var ttTextField: UITextField!
    
    @IBOutlet weak var wscTextField: UITextField!
    @IBOutlet weak var gacTextField: UITextField!
    @IBOutlet weak var pbcTextField: UITextField!

    @IBOutlet weak var mashLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var spargeLabel: UILabel!
    @IBOutlet weak var strikeTempLabel: UILabel!
    @IBOutlet weak var preBoilWortLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    var bottomTextFieldClicked: Bool = false
    
    // #pragma mark - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollview.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MashWaterViewController.didTapOnScreen(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(MashWaterViewController.goBack(_:)))
        swipeGesture.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MashWaterViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(MashWaterViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        loadConstants()
        applyStyle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // #pragma mark - Private
    func calculateMashSpargeWater() {
        let batchsize: Float = (self.bsTextField.text?.floatValue)!
        let grainbill: Float = (self.gaTextField.text?.floatValue)!
        var boiltime: Float = (self.btTextField.text?.floatValue)!
        let turbloss: Float = (self.tbTextField.text?.floatValue)!
        let equiploss: Float = (self.elTextField.text?.floatValue)!
        let mashthickness: Float = (self.mtTextField.text?.floatValue)!
        let graintemp: Float = (self.gtTextField.text?.floatValue)!
        let targettemp: Float = (self.ttTextField.text?.floatValue)!
        
        var wortshrinkage: Float = (self.wscTextField.text?.floatValue)!
        var grainabsorb: Float = (self.gacTextField.text?.floatValue)!
        var boiloffpercent: Float = (self.pbcTextField.text?.floatValue)!
        
        /* Convert percentages */
        boiltime *= 60
        wortshrinkage /= 100
        grainabsorb *= grainbill
        boiloffpercent /= 100
        
        /* Total Water Needed
        *  1-(Percent Evaporation * (Minutes Boiled/60)
        *  1-Percent Shrinkage = Shrinkage Factor
        *  (((batchsize + turbloss) / shrinkagefactor) / evaporaionfactor) = kettleloss
        *  kettleloss + mashtunloss + grainabsorbtionloss = total water needed
        */
        
        let evaporationLossFactor: Float = 1-(fabs(boiloffpercent) * (boiltime / 60))
        let shrinkageFactor: Float = 1-wortshrinkage
        
        let kettleloss: Float = (((batchsize+turbloss)/fabs(shrinkageFactor))/fabs(evaporationLossFactor))
        let totalWater: Float = fabs(kettleloss) + equiploss + fabs(grainabsorb)
        
        /* Mash / Sparge Water Volumes
        *  qt/lb (mashThickness * grainbill) / 4 = Gal. of Mash Water
        *  gal/lb mashThickness + grainbill = Gal. of Mash Water
        *  (.2/mashThickness)(targetTemp - initialTemp) + targetTemp
        */
        
        let mashwater: Float = (mashthickness * grainbill) / 4
        let spargewater: Float = totalWater - mashwater
        let striketemp: Float = (0.2/mashthickness) * (targettemp - graintemp) + targettemp
        
        let mashLit: Float = mashwater * 3.78541
        let spargeLit: Float = spargewater * 3.78541
        let totalLit: Float = totalWater * 3.78541
        let strikeTempC: Float = striketemp - 32 / 1.8
        let preBoilWortLit: Float = kettleloss * 3.78541
        
        // Results
        self.totalLabel.text = NSString(format: "%.2f gal. / %.2f L.", totalWater, totalLit) as String
        self.mashLabel.text = NSString(format: "%.2f gal / %.2f L.", mashwater, mashLit) as String
        self.spargeLabel.text = NSString(format: "%.2f gal / %.2f L.", spargewater, spargeLit) as String
        self.strikeTempLabel.text = NSString(format: "%.2f°F / %.2f°C", striketemp, strikeTempC) as String
        self.preBoilWortLabel.text = NSString(format: "%.2f gal. / %.2f L.", kettleloss, preBoilWortLit) as String
        
        storeConstants()
    }
    
    func storeConstants() {
        let wortshrinkage: String = self.wscTextField.text!
        let grainabsorb: String = self.gacTextField.text!
        let boiloffpercent: String = self.pbcTextField.text!
        
        UserDefaults.standard.set(wortshrinkage, forKey: "wort")
        UserDefaults.standard.set(grainabsorb, forKey: "grain")
        UserDefaults.standard.set(boiloffpercent, forKey: "boiloff")
    }
    
    func loadConstants() {
        var wortshrinkage = UserDefaults.standard.string(forKey: "wort")
        var grainaborb = UserDefaults.standard.string(forKey: "grain")
        var boiloffpercent = UserDefaults.standard.string(forKey: "boiloff")
        
        if (wortshrinkage == nil){
            wortshrinkage = "4%"
        }
        
        if (grainaborb == nil) {
            grainaborb = "0.13"
        }
        
        if (boiloffpercent == nil) {
            boiloffpercent = "10"
        }
        
        self.wscTextField.text = wortshrinkage
        self.gacTextField.text = grainaborb
        self.pbcTextField.text = boiloffpercent
    }
    
    func applyStyle() {
        self.view.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
        self.topView.backgroundColor = UIColor(netHex: BSColor.brewSnobGreen())
        
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        var userInfo = (notification as NSNotification).userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollview.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        self.scrollview.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollview.contentInset = contentInset
    }
    
    // #pragma mark - IBActions
    @IBAction func didTapCalculateButton(_ sender: AnyObject) {
        (sender as! UIView).shake()
        calculateMashSpargeWater()
    }
    
    @IBAction func didTapClear(_ sender: AnyObject) {
        (sender as! UIView).shake()
        for textField in textFieldArray {
            if (textField == wscTextField || textField == gacTextField || textField == pbcTextField) {
                continue
            }
            
            textField.text = ""
        }
        
        for label in labelArray {
            label.text = "0.00"
        }
    }
    
    @IBAction func didTapBackButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}



