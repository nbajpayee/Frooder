//
//  ViewController.swift
//  Frooder
//
//  Created by Neeraj Bajpayee on 11/15/14.
//  Copyright (c) 2014 Neeraj Bajpayee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var testTextField: UITextField!
    @IBOutlet weak var testReadButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var userNametxt: UITextField!
    @IBOutlet weak var userPasstxt: UITextField!
    @IBOutlet weak var foodItem: UITextField!
    @IBOutlet weak var howMuchAvailable: UIPickerView!
    
    @IBOutlet weak var continueView: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    let appId = "peOCyFSug2utyLbNmeoCmqXXL38hp2B1epY0UBOV"
    let clientKey = "H6gL0iFmKk7jCDT9danWB8zuMm5BpoPvkOvSNwkh"
    
    let userName = "hello"
    let password = "password"
    
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
        
        continueView.hidden = true
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        println("locations = \(locValue.latitude) \(locValue.longitude)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func getCurrentDateAndTime() -> (String) {
        
        let date = NSDate() //Get current date
        
        //Formatter for time
        let formatterTime = NSDateFormatter()
        formatterTime.timeStyle = .ShortStyle //Set style of time
        var timeString = formatterTime.stringFromDate(date) //Convert to String
        
        
        //Formatter for date
        let formatterDate = NSDateFormatter()
        formatterDate.dateStyle = .ShortStyle //Set style of date
        var dateString = formatterDate.stringFromDate(date) //Convert to String
        
        return (dateString + " " + timeString) //Returns a Tuple type
    }
    

    @IBAction func testSave()
    {
        Parse.setApplicationId(appId, clientKey: clientKey)
        
        if (foodItem.hasText())
        {
            var object = PFObject(className: "FoodItem")
            object.addObject(foodItem.text, forKey: "typeOfFood")
            //object.addObject(stillAvailable.text, forKey: "isStillAvailable")
            object.addObject(getCurrentDateAndTime(), forKey: "DateTime")
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
    
    
    
    // create User profiles
    func createUser(username:String, password:String) {
        var user = PFUser()
        user.username = username
        user.password = password
        
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
                NSLog("Created User")
               
            } else {
                
                let errorString = error.userInfo!["error"] as NSString
                // Show the errorString somewhere and let the user try again.
                
            }
        }
    }
    
    
    @IBAction func signUp(sender: UIButton) {
        NSLog("hasText", userNametxt.hasText())
        if (userNametxt.hasText() && userPasstxt.hasText()) {
            createUser(userNametxt.text, password: userPasstxt.text)
            userNametxt.text = ""
            userPasstxt.text = ""
        }
    }
    
    @IBAction func userLogin(sender: UIButton) {
        if (userNametxt.hasText() && userPasstxt.hasText()) {
            PFUser.logInWithUsernameInBackground(userNametxt.text, password: userPasstxt.text) {
            (user: PFUser!, error: NSError!) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    NSLog("Logged in")
                    
                    
                    self.continueView.hidden = false
                    self.loginButton.hidden = true
                    
                    
                } else {
                    // The login failed. Check error to see why.
                    NSLog("Login failed")
                    let alertController = UIAlertController(title: "Login failed!", message: "Try again!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            userPasstxt.text = ""
            userNametxt.text = ""
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

