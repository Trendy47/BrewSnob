//
//  BSLocationManager.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 10/13/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation
import CoreLocation

class BSLocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = BSLocationManager()
    
    let locationManager = CLLocationManager()
    var location: CLLocation!
    
    // #pragma mark - Public
    func initLocationManager() {
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdating() {
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        self.locationManager.stopUpdatingLocation()
    }
    
    // #pragma mark - CoreLocation Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //use the "locations" variable here
        self.location = manager.location!
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    
                    self.location = manager.location!
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error occured: \(error.localizedDescription).")
    }
}
