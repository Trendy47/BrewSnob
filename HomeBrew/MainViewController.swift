//
//  MainViewController.swift
//  BrewSnob
//
//  Created by Chris Tirendi on 4/13/15.
//  Copyright (c) 2015 Chris Tirendi. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet var buttonArray: [UIButton]!
    
    @IBOutlet weak var brewsButton: UIView!
    @IBOutlet weak var brewToolsButton: UIView!
    @IBOutlet weak var licensesButton: UIButton!
    
    // #pragma mark - Model
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        applyStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    // #pragma mark - Private
    func applyStyle() {
        buttonView.layer.cornerRadius = 4.0
        buttonView.backgroundColor = UIColor.clear
        
        self.view.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x328432)
        
        for button in buttonArray {
            button.layer.cornerRadius = 4.0
            button.backgroundColor = UIColor(netHex: BSColor.brewSnobMintGreen())
            
            var imageName = ""
            var x: CGFloat = 0
            
            if button.tag == 0 {
                imageName = "beer.png"
                x = 48
            } else {
                imageName = "lab-beaker.png"
                x = 43
            }
            
            let image = UIImage(named: imageName)
            let imageView = UIImageView(frame: CGRect(x: x, y: 15, width: 60, height: 60))
            imageView.layer.masksToBounds = true
            imageView.image = image
            button.addSubview(imageView)
        }
    }
    
    // #pragma mark - IBActions
    @IBAction func didTapCalculators(_ sender: AnyObject) {
        
        let nc = self.storyboard?.instantiateViewController(withIdentifier: "BrewToolsViewController") as? BrewToolsViewController
        self.navigationController?.pushViewController(nc!, animated: true)
    }
    
    @IBAction func didTapRecipes(_ sender: AnyObject) {
        
        let nc = self.storyboard?.instantiateViewController(withIdentifier: "BeerListViewController") as? BeerListViewController
        self.navigationController?.pushViewController(nc!, animated: true)
    }
    
    @IBAction func didTapLicensesButton(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "LicenseViewController")
        vc!.modalPresentationStyle = .popover

        let popover: UIPopoverPresentationController = vc!.popoverPresentationController!
        vc?.preferredContentSize = CGSize(width: 300, height: 200)
        popover.delegate = self
        popover.sourceView = sender
        popover.sourceRect = CGRect(x: 45, y: 5, width: 0, height: 0)
        
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func didTapMaps(_ sender: AnyObject) {
        
        let nc = self.storyboard?.instantiateViewController(withIdentifier: "MapsViewController") as? MapsViewController
        self.navigationController?.pushViewController(nc!, animated: true)
    }
    
    // #pragma mark - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


class LicenseViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         let str = "Icons made by Freepik at www.freepik.com from www.flaticon.com \nLicensed by Creative Commons BY 3.0 at creativecommons.org/licenses/by/3.0\n\nIcons made by Chanut Industries at www.flaticon.com/authors/chanut-is-industries from www.flaticon.com \nLicensed by Commons BY 3.0 at http://creativecommons.org/licenses/by/3.0"
        
        self.textView.text = str
        self.textView.font = UIFont.systemFont(ofSize: 16)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}








