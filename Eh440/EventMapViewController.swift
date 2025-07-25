//
//  MapViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-06-29.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation

class MapViewController: ContentViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var location: CLLocationCoordinate2D!
    var name = "Default"
    var locationName = "Default"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MKMapView()
        mapView.mapType = .Standard
        mapView.frame = view.frame
        mapView.delegate = self
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        
//        let location = CLLocationCoordinate2D(latitude: 40.3477778, longitude: -79.8644444)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = name
        annotation.subtitle = locationName
        mapView.addAnnotation(annotation)
        
        self.view.addSubview(mapView)
        
    }

}