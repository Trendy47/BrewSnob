//
//  CreateYeastViewController.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 3/19/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation
import UIKit

class CreateYeastViewController: UIViewController {
    
    @IBOutlet var textfieldArray: [UITextField]!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var attenuationTextField: UITextField!
    
    var yeast: NSDictionary!
    var isEditingYeast: Bool = false
    
    // #pragma mark - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let themeColor = UIColor(netHex: BSColor.brewSnobBlack())
        UIView.hr_setToastThemeColor(color: themeColor)
        
        applyStyle()
        
        if (yeast != nil) {
            loadViewWithObject()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateYeastViewController.didTapOnScreen(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func loadViewWithObject() {
        self.isEditingYeast = true
        self.createButton.setTitle("Save", for: UIControlState())
        
        let attenuation: Int = (self.yeast.object(forKey: "attenuation") as? Int)!
        
        self.nameTextField.text = self.yeast.object(forKey: "name") as? String
        self.attenuationTextField.text = "\(attenuation)"
    }
    
    // pragma mark - IBActions
    @IBAction func didTapCloseBtn(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapCreateBtn(_ sender: AnyObject) {
        var index = 0
        if (self.isEditingYeast) {
            let repo = RecipeManager.sharedInstance.yeastList
            index = repo.index(of: self.yeast)
            repo.remove(self.yeast)
        }
        
        let name: String? = self.nameTextField.text
        let attenuation: Float = (self.attenuationTextField.text?.floatValue)!
        
        let yeastDict: NSMutableDictionary = NSMutableDictionary()
        yeastDict.setValue(name, forKey: "name")
        yeastDict.setValue(attenuation, forKey: "attenuation")
        
        RecipeManager.sharedInstance.yeastList.insert(YeastObject(yeastDict), at: index)
        self.view.makeToast(message: "Yeast Created", duration: 2, position: HRToastPositionCenter as AnyObject)
        self.dismiss(animated: true, completion: nil)
    }
    
    // pragma mark - Private
    func applyStyle() {
        self.view.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
        self.topView.backgroundColor = UIColor(netHex: BSColor.brewSnobGreen())
        
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
}
