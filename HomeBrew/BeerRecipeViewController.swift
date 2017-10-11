//
//  BeerRecipeViewController.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 9/5/15.
//  Copyright (c) 2015 Chris Tirendi. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class BeerRecipeViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var textfieldArray: [UITextField]!
    @IBOutlet var textviewArray: [UITextView]!
    @IBOutlet var toolBarButtonArray: [UIButton]!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var directionsTextView: UITextView!
    @IBOutlet weak var fermentablesTextView: UITextView!
    @IBOutlet weak var hopsTextView: UITextView!
    @IBOutlet weak var yeastTextView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var ogLabel: UITextField!
    @IBOutlet weak var fgLabel: UITextField!
    @IBOutlet weak var abvLabel: UITextField!
    @IBOutlet weak var ibuLabel: UITextField!
    @IBOutlet weak var srmLabel: UITextField!
    @IBOutlet weak var batchSizeLabel: UITextField!
    @IBOutlet weak var boilSizeLabel: UITextField!
    @IBOutlet weak var efficiencyLabel: UITextField!
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var currentBeerRecipe:Beer!
    var section: Int!
    var isEditingRecipe: Bool! = false
    
    // #pragma mark - UIVIewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let themeColor = UIColor(netHex: BSColor.brewSnobBlack())
        UIView.hr_setToastThemeColor(color: themeColor)
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1000)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(BeerRecipeViewController.goBack(_:)))
        swipeGesture.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeGesture)
        
        applyStyle()
        useRecipe(self.currentBeerRecipe)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // #pragma mark - IBActions
    @IBAction func didTapEmailButton(_ sender: AnyObject) {
        
        //let beerXML = BeerXML.sharedInstance
        //beerXML.writeToXMLFile(currentBeerRecipe.beerDict!)
        
        let mailComposeVC = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeVC, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    @IBAction func didTapEditButton(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nc = storyboard.instantiateViewController(withIdentifier: "CustomBrewViewController") as! CustomBrewViewController
        
        nc.editBeer = self.currentBeerRecipe
        self.navigationController?.pushViewController(nc, animated: true)
    }
    
    @IBAction func didTapBackButton(_ sender: AnyObject) {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goBack(_ gesture: UISwipeGestureRecognizer) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // #pragma mark - Private
    func applyStyle() {
        self.view.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
        self.topView.backgroundColor = UIColor(netHex: BSColor.brewSnobGreen())
        
        for textview in textviewArray {
//            textview.layer.cornerRadius = 3
//            textview.backgroundColor = UIColor.init(netHex: BSColor.brewSnobGrey())
            textview.backgroundColor = UIColor.clear
            textview.textColor = UIColor.black
        }
        
        let ix = ingredientsTextView.frame.origin.x
        let iy = ingredientsTextView.frame.origin.y
        
        let dx = directionsTextView.frame.origin.x
        let dy = directionsTextView.frame.origin.y
        
        let fx = fermentablesTextView.frame.origin.x
        let fy = fermentablesTextView.frame.origin.y
        
        let hx = hopsTextView.frame.origin.x
        let hy = hopsTextView.frame.origin.y
        
        let yx = yeastTextView.frame.origin.x
        let yy = yeastTextView.frame.origin.y
        
        var size = ingredientsTextView.sizeThatFits(CGSize(width: self.view.frame.size.width,  height: CGFloat(Float.greatestFiniteMagnitude)))
        ingredientsTextView.frame = CGRect(x: ix, y: iy, width: size.width, height: size.height)
        
        size = directionsTextView.sizeThatFits(CGSize(width: self.view.frame.size.width,  height: CGFloat(Float.greatestFiniteMagnitude)))
        directionsTextView.frame = CGRect(x: dx, y: dy, width: size.width, height: size.height)
        
        size = fermentablesTextView.sizeThatFits(CGSize(width: self.view.frame.size.width,  height: CGFloat(Float.greatestFiniteMagnitude)))
        fermentablesTextView.frame = CGRect(x: fx, y: fy, width: size.width, height: size.height)
        
        size = hopsTextView.sizeThatFits(CGSize(width: self.view.frame.size.width,  height: CGFloat(Float.greatestFiniteMagnitude)))
        hopsTextView.frame = CGRect(x: hx, y: hy, width: size.width, height: size.height)
        
        size = yeastTextView.sizeThatFits(CGSize(width: self.view.frame.size.width,  height: CGFloat(Float.greatestFiniteMagnitude)))
        yeastTextView.frame = CGRect(x: yx, y: yy, width: size.width, height: size.height)
    }
    
    func didTapOnScreen(_ gesture: UITapGestureRecognizer) {
        for textField in textfieldArray {
            textField.resignFirstResponder()
        }
        
        for textView in textviewArray {
            textView.resignFirstResponder()
        }
    }
    
    func useRecipe(_ beer:Beer) {
        var unit: String = ""
        if (beer.unit == "US") {
            unit = "Gallons"
        } else {
            unit = "Liters"
        }
        
        // Fill in the data
        self.beerNameLabel.text = beer.beerName
        self.ogLabel.text = beer.oGravity
        self.fgLabel.text = beer.fGravity
        self.abvLabel.text = beer.abv
        self.ibuLabel.text = beer.ibu
        self.srmLabel.text = beer.srm
        
        self.batchSizeLabel.text = String(format: "%@ %@", arguments: [beer.batchSize!, unit])
        self.boilSizeLabel.text = String(format: "%@ %@ @ %@ min", arguments: [beer.boilSize!, unit, beer.boilTime!])
        
        self.efficiencyLabel.text = beer.efficiency! + "%"
        
        self.fermentablesTextView.text = beer.fermentables
        self.hopsTextView.text = beer.hops
        self.yeastTextView.text = beer.yeasts
        self.ingredientsTextView.text = beer.ingredients
        self.directionsTextView.text = beer.directions
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["recicpient@example.com"])
        mailComposerVC.setSubject("BrewSnob Recipe")
        
        mailComposerVC.setMessageBody("Your BeerXML File", isHTML: false)
        
        let name = NSString(format: "%@.xml", currentBeerRecipe.beerName!)
        let filePath = BSString.recipesPath().appendingPathComponent((name as String))
        let alteredPath = filePath.absoluteString.replacingOccurrences(of: "file:///", with: "")
        
        if let fileData = try? Data(contentsOf: URL(fileURLWithPath: alteredPath)) {
            mailComposerVC.addAttachmentData(fileData, mimeType: "application/xml", fileName: name as String)
        }
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func textViewDidChange(_ textview: UITextView) {
        let fixedWidth = textview.frame.size.width
        textview.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let newSize = textview.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textview.frame
        
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textview.frame = newFrame;
    }
    
    // #pragma mark - MFMailComposeDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
