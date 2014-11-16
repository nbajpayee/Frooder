//
//  availableFoodsViewController.swift
//  Frooder
//
//  Created by Neeraj Bajpayee on 11/16/14.
//  Copyright (c) 2014 Neeraj Bajpayee. All rights reserved.
//
import UIKit
import Foundation


class availableFoodsViewController: UIViewController, CLLocationManagerDelegate {
    
    let appId = "peOCyFSug2utyLbNmeoCmqXXL38hp2B1epY0UBOV"
    let clientKey = "H6gL0iFmKk7jCDT9danWB8zuMm5BpoPvkOvSNwkh"
    var manager:CLLocationManager!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setup our Location Manager
        manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()
        }
    }
    
    
    
    
}