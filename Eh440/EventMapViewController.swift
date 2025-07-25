//
//  MapViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-06-29.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit
import MapKit

class EventMapViewController: ContentViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var event: EventDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MKMapView()
        mapView.mapType = .standard
        mapView.frame = view.frame
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: event.coordinates, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = event.coordinates
        annotation.title = event.venue
        annotation.subtitle = event.location
        mapView.addAnnotation(annotation)
        
        self.view.addSubview(mapView)
        
    } // viewDidLoad()

} // EventMapViewController()
