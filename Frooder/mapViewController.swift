//
//  mapViewController.swift
//  Frooder
//
//  Created by Neeraj Bajpayee on 11/16/14.
//  Copyright (c) 2014 Neeraj Bajpayee. All rights reserved.
//

import UIKit
import Foundation
import MapKit


class mapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var theMap: MKMapView!
    
    let appId = "peOCyFSug2utyLbNmeoCmqXXL38hp2B1epY0UBOV"
    let clientKey = "H6gL0iFmKk7jCDT9danWB8zuMm5BpoPvkOvSNwkh"
    var manager:CLLocationManager!
    var foodName: String!
    var location: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint!, error: NSError!) -> Void in
            if error == nil {
                // do something with the new geoPoint
                NSLog("Found location");
                
                let location = CLLocationCoordinate2D(
                    latitude: geoPoint.latitude,
                    longitude: geoPoint.longitude
                )
        
                // 2
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: location, span: span)
                self.theMap.setRegion(region, animated: true)
                
                //3
                let annotation = MKPointAnnotation()
                annotation.setCoordinate(location)
                annotation.title = "Big Ben"
                annotation.subtitle = "London"
                self.theMap.addAnnotation(annotation)
                
                
                
            } else {
                NSLog("Did not find location");
            }
        }
        
        
        
    }
    
}