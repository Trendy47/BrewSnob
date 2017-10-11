//
//  SearchViewController.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 6/19/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var ingredientsSearchBar: UISearchBar!
    
    var searchActive: Bool = false
    var tableData = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filtered:[String] = []
    
    // #pragma mark - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ingredientsSearchBar.delegate = self
        self.searchTableView.delegate = self
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(SearchViewController.goBack(_:)))
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
    
    
    // #pragma mark - UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = tableData.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        
        if (filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.searchTableView.reloadData()
    }
    
    // #pragma mark - UITableViewDelegate
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive) {
            return filtered.count
        }
        return tableData.count;
    }
    
    @nonobjc func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchTableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell;
        if (searchActive) {
            cell.textLabel?.text = filtered[(indexPath as NSIndexPath).row]
        } else {
            cell.textLabel?.text = tableData[(indexPath as NSIndexPath).row];
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // #pragma mark - IBActions
    @IBAction func didTapBackButton(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    // #pragma mark - Private
    func applyStyle() {
        
    }
    
    @objc func goBack(_ gesture: UISwipeGestureRecognizer) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
