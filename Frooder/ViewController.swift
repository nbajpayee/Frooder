//
//  ViewController.swift
//  Frooder
//
//  Created by Neeraj Bajpayee on 11/15/14.
//  Copyright (c) 2014 Neeraj Bajpayee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var testTextField: UITextField!
    
    @IBOutlet weak var testReadButton: UIButton!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    var manager:CLLocationManager!
    
    override func viewDidLoad() {
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
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        println("locations = \(locValue.latitude) \(locValue.longitude)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func testSave()
    {
        Parse.setApplicationId("peOCyFSug2utyLbNmeoCmqXXL38hp2B1epY0UBOV", clientKey: "H6gL0iFmKk7jCDT9danWB8zuMm5BpoPvkOvSNwkh")
        var object = PFObject(className: "FoodItem")
        object.addObject("Banana", forKey: "typeOfFood")
        object.addObject(true, forKey: "isStillAvailable")
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint!, error: NSError!) -> Void in
            if error == nil {
                // do something with the new geoPoint
                object.addObject(geoPoint, forKey: "location")
                object.saveInBackgroundWithTarget(nil, selector: nil)
                NSLog("Found location");
                self.testTextField.text = "found"
            } else {
                NSLog("Did not find location");
                self.testTextField.text = "not found"
                object.saveInBackgroundWithTarget(nil, selector: nil)

            }
        }
        //object.addObject("truck", forKey: "location")

        
        
        let alertController = UIAlertController(title: "Thanks for feeding us!", message: "We love you!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func testRead()
    {
        testTextField.text = "Testing"
    Parse.setApplicationId("peOCyFSug2utyLbNmeoCmqXXL38hp2B1epY0UBOV", clientKey: "H6gL0iFmKk7jCDT9danWB8zuMm5BpoPvkOvSNwkh")
        
        var query = PFQuery(className:"FoodItem")
        query.whereKey("typeOfFood", equalTo:"Banana")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                NSLog("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                self.testTextField.text = "Found \(objects.count) bananas"
                for object in objects {
                    NSLog("%@", object.objectId)
                }
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    @IBAction func getLocation(sender: UIButton) {
//        
//        PFGeoPoint.geoPointForCurrentLocationInBackground {
//            (geoPoint: PFGeoPoint!, error: NSError!) -> Void in
//            if error == nil {
//                // do something with the new geoPoint
//                geoPoint.saveInBackgroundWithTarget(nil, selector: nil)
//            }
//        }
    }
    
}

