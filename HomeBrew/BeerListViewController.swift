//
//  BeerListViewController.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 9/5/15.
//  Copyright (c) 2015 Chris Tirendi. All rights reserved.
//

import Foundation
import UIKit

class BeerListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var beerArray: NSMutableArray = []
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    
    // #pragma mark - Model
    func loadModel() {
        beerArray = []
        
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: BSString.recipesPath() as URL, includingPropertiesForKeys: nil, options:FileManager.DirectoryEnumerationOptions())
            
            for file in directoryContents {
                let path = NSString(format: "%@", file as CVarArg).replacingOccurrences(of: "file:///private", with: "")
                beerArray.addObjects(from: Beer.loadRecipeFromFile(path as String))
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // #pragma mark - Private
    func applyStyle() {
        self.view.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
        self.topView.backgroundColor = UIColor(netHex: BSColor.brewSnobGreen())
        self.tableView.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
    }
    
    // #pragma mark - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.rowHeight = 70.0
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = UIView()
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(BeerListViewController.goBack(_:)))
        swipeGesture.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeGesture)
        
        loadModel()
        applyStyle()
        
        if (self.beerArray.count == 0) {
            self.infoLabel.isHidden = false
        } else {
            self.infoLabel.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadModel()
        self.tableView.reloadData()
        
        if (self.beerArray.count == 0) {
            self.infoLabel.isHidden = false
        } else {
            self.infoLabel.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
        
    // #pragma mark - IBActions
    @IBAction func didTapCustomBrew(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nc = storyboard.instantiateViewController(withIdentifier: "CustomBrewViewController") as! CustomBrewViewController
        self.navigationController?.pushViewController(nc, animated: true)
    }
    
    @IBAction func didTapBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goBack(_ gesture: UISwipeGestureRecognizer) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // #pragma mark - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beerRecipeCell", for: indexPath) as! CustomTableViewCell
        
        let beer: Beer = beerArray[(indexPath as NSIndexPath).row] as! Beer
        cell.useBeer(beer)
        
        cell.backgroundColor = UIColor(netHex: BSColor.brewSnobBackgroundColor())
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = "Custom Recipes";
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
            let beer: Beer = beerArray[(indexPath as NSIndexPath).row] as! Beer
            let rowText = beer.beerName!.replacingOccurrences(of: " ", with: "")
            
            // deletes the file
            do {
                let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
                let customBeerPath = documentsPath.appendingPathComponent("Recipes")
                
                let path = NSString(format: "%@%@.json", customBeerPath as CVarArg, rowText).replacingOccurrences(of: "file:///", with: "")
                
                try FileManager.default.removeItem(atPath: path as String)
                
            } catch let error as NSError {
                print("ERROR: \(error)")
            }
            
            // removes from array
            beerArray.removeObject(at: (indexPath as NSIndexPath).row)
            
            // removes tableViewRow and reloads the tableView
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
        }
    }
    
    // #pragma mark - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beer: Beer = beerArray[(indexPath as NSIndexPath).row] as! Beer
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nc = storyboard.instantiateViewController(withIdentifier: "BeerRecipeViewController") as! BeerRecipeViewController
        
        nc.currentBeerRecipe = beer;
        nc.section = (indexPath as NSIndexPath).section
        
        self.navigationController?.pushViewController(nc, animated: true)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
