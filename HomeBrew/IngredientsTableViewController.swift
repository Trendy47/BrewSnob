//
//  IngredientsTableView.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 6/11/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation
import UIKit

class IngredientsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableData: NSMutableArray = []
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    // #pragma mark - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        let fermentables = RecipeManager.sharedInstance.fermentList
        let hops = RecipeManager.sharedInstance.hopList
        let yeast = RecipeManager.sharedInstance.yeastList
        
        self.tableData = [fermentables, hops, yeast]
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(IngredientsTableViewController.goBack(_:)))
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
    
    // #pragma mark - Private
    func applyStyle() {
        self.view.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
        self.topView.backgroundColor = UIColor(netHex: BSColor.brewSnobGreen())
        self.tableView.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
    }
    
    // #pragma mark - IBActions
    @IBAction func didTapBackButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goBack(_ gesture: UISwipeGestureRecognizer) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // #pragma mark - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.tableData[section] as AnyObject).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "fermentableCell", for: indexPath) as! FermentableCell
            
            let fermentable = RecipeManager.sharedInstance.fermentList[(indexPath as NSIndexPath).row]
            cell.createFermentableCell(fermentable as! NSDictionary)
            
            return cell
        }
        
        else if (indexPath as NSIndexPath).section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "hopsCell", for: indexPath) as! HopsCell
            
            let hop = RecipeManager.sharedInstance.hopList[(indexPath as NSIndexPath).row]
            cell.createHopsCell(hop as! NSDictionary)
            
            return cell
        }
        
        else if (indexPath as NSIndexPath).section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "yeastCell", for: indexPath) as! YeastCell
            
            let yeast = RecipeManager.sharedInstance.yeastList[(indexPath as NSIndexPath).row]
            cell.createYeastCell(yeast as! NSDictionary)
            
            return cell
        }
       
        // return empty cell?
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitles = ["Fermentables", "Hops", "Yeast"]
        var title = ""
        
        if section < headerTitles.count {
            title = headerTitles[section]
        }
        
        let returnedView = UIView(frame: CGRect(x: tableView.frame.origin.x, y: 60, width: tableView.frame.size.width, height: 45))
        returnedView.backgroundColor = UIColor(netHex: BSColor.brewSnobBrown())
        
        let label = UILabel(frame: CGRect(x: 8, y: -5, width: 250, height: 35))
        label.text = title
        label.textColor = UIColor.white
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.tableView.beginUpdates()
            
            if (indexPath as NSIndexPath).section == 0 {
                RecipeManager.sharedInstance.fermentList.removeObject(at: (indexPath as NSIndexPath).row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            else if (indexPath as NSIndexPath).section == 1 {
                RecipeManager.sharedInstance.hopList.removeObject(at: (indexPath as NSIndexPath).row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            else if (indexPath as NSIndexPath).section == 2 {
                RecipeManager.sharedInstance.yeastList.removeObject(at: (indexPath as NSIndexPath).row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            self.tableView.reloadData()
            self.tableView.endUpdates()
        }
    }
    
    // #pragma mark - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Ingredients", bundle: Bundle.main)
        if (indexPath as NSIndexPath).section == 0 {
            let vc = storyboard.instantiateViewController(withIdentifier: "CreateFermentableViewController") as! CreateFermentableViewController
            
            let dict = (self.tableData[(indexPath as NSIndexPath).section] as! NSDictionary)[(indexPath as NSIndexPath).row]
            vc.fermentable = dict as! NSDictionary
            
            self.present(vc, animated: true, completion: nil)
        }
            
        else if (indexPath as NSIndexPath).section == 1 {
            let vc = storyboard.instantiateViewController(withIdentifier: "CreateHopsViewController") as! CreateHopsViewController
            
            let dict = (self.tableData[(indexPath as NSIndexPath).section] as! NSDictionary)[(indexPath as NSIndexPath).row]
            vc.hop = dict as! NSDictionary
            
            self.present(vc, animated: true, completion: nil)
        }
            
        else if (indexPath as NSIndexPath).section == 2 {
            let vc = storyboard.instantiateViewController(withIdentifier: "CreateYeastViewController") as! CreateYeastViewController
            
            let dict = (self.tableData[(indexPath as NSIndexPath).section] as! NSDictionary)[(indexPath as NSIndexPath).row]
            vc.yeast = dict as! NSDictionary
            
            self.present(vc, animated: true, completion: nil)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
