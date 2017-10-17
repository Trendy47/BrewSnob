//
//  BrewToolsViewController.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 10/11/15.
//  Copyright © 2015 Chris Tirendi. All rights reserved.
//

import Foundation
import UIKit

class BrewToolsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var tools:[String] = []
    
    // #pragma mark - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tools = [ "Simple Calculators", "Brew Timer", "IBU Calculator", "Mash Water and Sparge Calculator", "Mash Infusion Calculator"];
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(BrewToolsViewController.goBack(_:)))
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
    
    @IBAction func didTapBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // #pragma mark - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "brewToolsCell", for: indexPath) as! CustomTableViewCell
        
        let tool = tools[indexPath.row]
        var imageName = ""
        
        switch indexPath.row {
        case 0:
            imageName = "calculator.png"
            break
        case 1:
            imageName = "hour_glass.png"
            break
        case 2:
            imageName = "hop.png"
            break
        case 3:
            imageName = "drop.png"
            break
        case 4:
            imageName = "malt.png"
            break
        default:
            break
        }
        
        cell.useTool(tool, imageName)
        cell.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // #pragma mark - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        
        let tool: String = tools[(indexPath as NSIndexPath).row]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if tool.isEqual("Simple Calculators") {
            
            let nc = storyboard.instantiateViewController(withIdentifier: "ABVViewController") as! ABVViewController
            self.navigationController?.pushViewController(nc, animated: true)
            
        } else if tool.isEqual("IBU Calculator") {
            
            let nc = storyboard.instantiateViewController(withIdentifier: "IBUViewController") as! IBUViewController
            self.navigationController?.pushViewController(nc, animated: true)
            
        } else if tool.isEqual("Mash Water and Sparge Calculator") {
            
            let nc = storyboard.instantiateViewController(withIdentifier: "MashWaterViewController") as! MashWaterViewController
            self.navigationController?.pushViewController(nc, animated: true)
            
        } else if tool.isEqual("Mash Infusion Calculator") {
            
            let nc = storyboard.instantiateViewController(withIdentifier: "MashInfusionViewController") as! MashInfusionViewController
            self.navigationController?.pushViewController(nc, animated: true)
            
        } else if tool.isEqual("Brew Timer") {
            
            let nc = storyboard.instantiateViewController(withIdentifier: "BTTimerViewController") as! BTTimerViewController
            self.navigationController?.pushViewController(nc, animated: true)
        }
    }

    // #pragma mark - Private
    func applyStyle() {
        self.tableView.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
        self.tableView.rowHeight = 85.0
        
        self.view.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
        self.topView.backgroundColor = UIColor(netHex: BSColor.brewSnobGreen())
    }
    
    @objc func goBack(_ gesture: UISwipeGestureRecognizer) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
