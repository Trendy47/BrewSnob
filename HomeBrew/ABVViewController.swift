//
//  CalculatorsViewController.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 10/1/15.
//  Copyright © 2015 Chris Tirendi. All rights reserved.
//

import Foundation
import UIKit

class ABVViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet var viewArray: [UIView]!
    @IBOutlet var textFieldArray: [UITextField]!
    
    @IBOutlet weak var ogAbvTextField: UITextField!
    @IBOutlet weak var fgAbvTextField: UITextField!
    @IBOutlet weak var abvTextField: UITextField!
    @IBOutlet weak var abwTextField: UITextField!
    
    @IBOutlet weak var cgMpeTextField: UITextField!
    @IBOutlet weak var fgMpeTextField: UITextField!
    @IBOutlet weak var peMpeTextField: UITextField!
    @IBOutlet weak var ppgMpeTextField: UITextField!
    
    @IBOutlet weak var srmCCTextField: UITextField!
    @IBOutlet weak var loviCCTextField: UITextField!
    @IBOutlet weak var ebCCTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var bottomTextFieldClicked: Bool = false
    
    // #pragma mark - UIVIewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ABVViewController.calculatePPG), name: NSNotification.Name.UITextFieldTextDidChange, object: self.cgMpeTextField)
        NotificationCenter.default.addObserver(self, selector: #selector(ABVViewController.calculatePPG), name: NSNotification.Name.UITextFieldTextDidChange, object: self.fgMpeTextField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ABVViewController.calculateColor), name: NSNotification.Name.UITextFieldTextDidChange, object: self.srmCCTextField)
        NotificationCenter.default.addObserver(self, selector: #selector(ABVViewController.calculateColor), name: NSNotification.Name.UITextFieldTextDidChange, object: self.loviCCTextField)
        NotificationCenter.default.addObserver(self, selector: #selector(ABVViewController.calculateColor), name: NSNotification.Name.UITextFieldTextDidChange, object: self.ebCCTextField)
        NotificationCenter.default.addObserver(self,selector:#selector(ABVViewController.calculateAbv), name: NSNotification.Name.UITextFieldTextDidChange, object: self.ogAbvTextField)
        NotificationCenter.default.addObserver(self,selector:#selector(ABVViewController.calculateAbv), name: NSNotification.Name.UITextFieldTextDidChange, object: self.fgAbvTextField)
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ABVViewController.didTapOnScreen(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ABVViewController.goBack(_:)))
        swipeGesture.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ABVViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(ABVViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
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
    
    // #pragma mark - IBActions
    @IBAction func didTapBack(_ sender: AnyObject) {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goBack(_ gesture: UISwipeGestureRecognizer) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapOnScreen(_ gesture: UITapGestureRecognizer) {
        for textField in textFieldArray {
            textField.resignFirstResponder()
        }
    }
    
    // #pragma mark - Calculations
    @objc func calculateAbv() {
        let og: Float = (ogAbvTextField.text?.floatValue)!
        let fg: Float = (fgAbvTextField.text?.floatValue)!
        
        // -17.1225210+146.6266588*OG-130.2323766*FG
        // ( (OG-FG)*(832+OG)*(832+FG) )/5500000
        // ABV = 147*OG - 130*FG -17
        
        //let abv:Float = ((76.08 * (og - fg) / (1.775 - og)) * (fg / 0.794))
        let abv: Float = (og - fg) * 131
        let abw: Float = 0.789 * abv / (1 - 0.211 * abv)
        
        self.abvTextField.text = String(format: "%.2f %", abv)
        self.abwTextField.text = String(format: "%.2f %", abw)
    }
    
    @objc func calculatePPG() {
        let cg: Float = (cgMpeTextField.text?.floatValue)!
        let fg: Float = (fgMpeTextField.text?.floatValue)!
        
        let ppg: Float = (((cg + fg) / 2) / 100) * 46
        let pe: Float = (ppg / 1000) + 1
        
        self.ppgMpeTextField.text = String(format: "%.0f", ppg)
        self.peMpeTextField.text = String(format: "%.3f", pe)
    }
    
    @objc func calculateColor() {
        var SRM: Float = (srmCCTextField.text?.floatValue)!
        var L: Float = (loviCCTextField.text?.floatValue)!
        var EBC: Float = (ebCCTextField.text?.floatValue)!
        
        if (SRM != 0) {
            EBC = SRM * 1.97
            L = (SRM + 0.76) / 1.3546
            
            self.srmCCTextField.text = String(format: "%.1f", SRM)
            self.loviCCTextField.text = String(format: "%.1f", L)
            self.ebCCTextField.text = String(format: "%.1f", EBC)
            
            SRM = 0;
            L = 0;
            EBC = 0;
        } else if (L != 0) {
            SRM = (1.3546 * L) - 0.76
            EBC = SRM * 1.97
            
            self.srmCCTextField.text = String(format: "%.1f", SRM)
            self.loviCCTextField.text = String(format: "%.1f", L)
            self.ebCCTextField.text = String(format: "%.1f", EBC)
            
            SRM = 0;
            L = 0;
            EBC = 0;
        } else if (EBC != 0) {
            SRM = EBC * 0.508
            L = (SRM + 0.76) / 1.3546
            
            self.srmCCTextField.text = String(format: "%.1f", SRM)
            self.loviCCTextField.text = String(format: "%.1f", L)
            self.ebCCTextField.text = String(format: "%.1f", EBC)
            
            SRM = 0;
            L = 0;
            EBC = 0;
        }
    }
    
    // #pragma mark - Private
    func applyStyle() {
        self.view.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
        self.topView.backgroundColor = UIColor(netHex: BSColor.brewSnobGreen())
        
        for view in viewArray {
            view.layer.cornerRadius = 4
            view.layer.masksToBounds = true
            view.backgroundColor = UIColor(netHex: BSColor.brewSnobGreen())
        }
        
        for textField in textFieldArray {
            textField.layer.cornerRadius = 2.0
            textField.backgroundColor = UIColor(netHex: BSColor.brewSnobGrey())
        }
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
