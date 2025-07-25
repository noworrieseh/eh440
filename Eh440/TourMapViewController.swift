//
//  TourMapViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-17.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit
import MapKit

class ColorPointAnnotation: MKPointAnnotation {
    var pinColor: UIColor
    
    init(pinColor: UIColor) {
        self.pinColor = pinColor
        super.init()
    }
}

class TourMapViewController: ContentViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var upcoming: [EventDetails]!
    var past: [EventDetails]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MKMapView()
        mapView.mapType = .standard
        mapView.frame = view.frame
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
 
        // Map Upcoming Tour dates
        for item in upcoming {
            let annotation = ColorPointAnnotation(pinColor: UIColor.green)
            annotation.coordinate = item.coordinates
            annotation.title = item.venue
            annotation.subtitle = item.location
            mapView.addAnnotation(annotation)
        } // for
        
        // Map Past Tour dates
        for item in past {
            let annotation = ColorPointAnnotation(pinColor: UIColor.red)
            annotation.coordinate = item.coordinates
            annotation.title = item.venue
            annotation.subtitle = item.location
            mapView.addAnnotation(annotation)
        } // for
        
        self.view.addSubview(mapView)
        
    } // viewDidLoad()
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
        } else {
            pinView?.annotation = annotation
        } // if
        
        let colorPointAnnotation = annotation as! ColorPointAnnotation
        pinView?.pinTintColor = colorPointAnnotation.pinColor
     
        return pinView
    } // Map: Annotation view
    
} // TourMapViewController()
