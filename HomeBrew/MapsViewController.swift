//
//  MapsViewController.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 9/27/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation
import MapKit

class MapsViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backButton: UIButton!
    
    //let mapsDelegate: BSMapDelegate
    
    let regionRadius: CLLocationDistance = 1000
    
    var bsLocationManager: BSLocationManager!
    
    // #pragma mark - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bsLocationManager = BSLocationManager.sharedInstance
        self.bsLocationManager.initLocationManager()
        self.bsLocationManager.startUpdating()
        
        applyStyle()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.addPinToMap(gesture:)))
        longPressGesture.minimumPressDuration = 2.0
        
        self.mapView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let loc: CLLocation = self.bsLocationManager.location
        centerMapOnLocation(location: loc)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.bsLocationManager.stopUpdating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    // #pragma mark - IBActions
    @objc func addPinToMap(gesture: UIGestureRecognizer) {
        if gesture.state == .began {
            
            let touchPoint = gesture.location(in: self.mapView)
            let convertCoords = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = convertCoords
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: convertCoords.latitude, longitude: convertCoords.longitude), completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                
                annotation.title = "Your new pin"
                self.mapView.addAnnotation(annotation)
            })
        }
    }
    
    @IBAction func didTapBack(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    // #pragma mrk - Private
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func applyStyle() {
        
    }
}
