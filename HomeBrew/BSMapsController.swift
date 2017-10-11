//
//  BSMapsController.swift
//  HomeBrew
//
//  Created by Chris Tirendi on 10/18/16.
//  Copyright © 2016 Chris Tirendi. All rights reserved.
//

import Foundation
import MapKit

protocol BSMapDelegate: class {
    func addPinToMap(gesture: UIGestureRecognizer)
}

final class BSMapController: BSMapDelegate {
    
    let mapView: MKMapView
    
    init(mapView: MKMapView) {
        self.mapView = mapView
    }
    
    func addPinToMap(gesture: UIGestureRecognizer) {
        
    }
}




