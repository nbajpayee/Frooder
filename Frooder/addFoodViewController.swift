//
//  addFoodViewController.swift
//  Frooder
//
//  Created by Neeraj Bajpayee on 11/15/14.
//  Copyright (c) 2014 Neeraj Bajpayee. All rights reserved.
//

import UIKit
import Foundation

class addFoodViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var foodItem: UITextField!
    @IBOutlet weak var quantityItem: UITextField!
    @IBOutlet weak var whereText: UITextField!
    @IBOutlet weak var timeLimit: UITextField!
    @IBOutlet weak var providerRadius: UITextField!
    
    let appId = "peOCyFSug2utyLbNmeoCmqXXL38hp2B1epY0UBOV"
    let clientKey = "H6gL0iFmKk7jCDT9danWB8zuMm5BpoPvkOvSNwkh"
    
    var manager:CLLocationManager!
    
    override func touchesBegan(touches: (NSSet!), withEvent event: (UIEvent!)){
        self.view.endEditing(true)
    }
    
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
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func saveFood(sender: UIButton) {
        Parse.setApplicationId(appId, clientKey: clientKey)
        
        if (foodItem.hasText())
        {
            var object = PFObject(className: "FoodItem")
            object.addObject(foodItem.text, forKey: "typeOfFood")
            object.addObject(quantityItem.text, forKey: "quantity")
            object.addObject(whereText.text, forKey: "locationText")
            object.addObject(timeLimit.text, forKey: "timeLimit")
        object.addObject(providerRadius.text, forKey: "distanceProvider")
            object.addObject(true, forKey: "isStillAvailable")
            PFGeoPoint.geoPointForCurrentLocationInBackground {
                (geoPoint: PFGeoPoint!, error: NSError!) -> Void in
                if error == nil {
                    // do something with the new geoPoint
                    object.addObject(geoPoint, forKey: "location")
                    object.saveInBackgroundWithTarget(nil, selector: nil)
                    NSLog("Found location");
                } else {
                    NSLog("Did not find location");
                    object.saveInBackgroundWithTarget(nil, selector: nil)
                    
                }
                self.foodItem.text = ""
                self.quantityItem.text = ""
                self.whereText.text = ""
                self.timeLimit.text = ""
                self.providerRadius.text = ""
                
                
            }
            
            
            let alertController = UIAlertController(title: "Thanks for feeding us!", message: "We love you!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    
}