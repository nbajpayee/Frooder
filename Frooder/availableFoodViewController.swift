//
//  availableFoodViewController.swift
//  Frooder
//
//  Created by Neeraj Bajpayee on 11/15/14.
//  Copyright (c) 2014 Neeraj Bajpayee. All rights reserved.
//


//import UIKit
//import Foundation


//class availableFoodViewController: UIViewController, CLLocationManagerDelegate {
//    
//    let appId = "peOCyFSug2utyLbNmeoCmqXXL38hp2B1epY0UBOV"
//    let clientKey = "H6gL0iFmKk7jCDT9danWB8zuMm5BpoPvkOvSNwkh"
//    var manager:CLLocationManager!
//    var theMapView: UIViewController!
//    
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        //Setup our Location Manager
//        manager = CLLocationManager()
//        manager.requestAlwaysAuthorization()
//        if (CLLocationManager.locationServicesEnabled())
//        {
//            manager.delegate = self
//            manager.desiredAccuracy = kCLLocationAccuracyBest
//            manager.startUpdatingLocation()
//        }
//    }
//    
//    
//    
////    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
////        theMapView.foodName =
////        theMapView.location =
////    }
//    
//}


import UIKit

class availableFoodViewController:UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    struct Candy {
        let name : String
    }
    
    struct Distance {
        var number : Float?
    }
    
    struct bright {
        let colour : String
    }
    
    var placesObjects = [PFObject]()
    var userLocation : PFGeoPoint

    
    var candies = [Candy]()
    var distances = [Distance]()
    
    var currentlySelectedRow : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        PFGeoPoint.geoPointForCurrentLocationInBackground{
            (geoPoint:PFGeoPoint!, error: NSError!) -> Void in
            if error == nil {
                var query = PFQuery(className:"FoodItem")
                
                query.whereKey("location", nearGeoPoint:geoPoint)
                
                query.limit = 20
                self.placesObjects = query.findObjects() as [PFObject]
                self.userLocation = geoPoint
                
                
                var currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject("Princeton", forKey: "channels")
                currentInstallation.setObject(geoPoint, forKey: "location")
                currentInstallation.saveInBackgroundWithTarget(nil, selector: nil)
            }
        }
        
        
        
        
        
        self.candies = [Candy(name: "Pizza" ), Candy(name: "Burger"),Candy(name: "Cheese Steak"), Candy(name: "Pasta")]
        self.distances = [Distance (number: 1.0), Distance(number: 1.0), Distance(number: 1.0),Distance(number: 1.0)]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.candies.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if currentlySelectedRow != nil {
            if currentlySelectedRow! == indexPath.row {
                return 100
            }
        }
        return 70
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cellIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        var candy : Candy
        var distance : Distance
        candy = Candy(name:(placesObjects[indexPath.row])["typeOfFood"] as String)
        var location = (placesObjects[indexPath.row])["location"] as PFGeoPoint
        var floatNum = Float(userLocation.latitude - location.latitude + userLocation.longitude - location.latitude)
        distance = Distance(number: floatNum)
        distance.number = distance.number! * distance.number!
        cell.detailTextLabel!.text = nil
        cell.detailTextLabel!.hidden = false
        println("cellForRowAtIndexPath called with indexPath: \(indexPath.row)")
        
        if currentlySelectedRow != nil {
            if currentlySelectedRow! == indexPath.row {
                // println("currentlySelectedRow is \(currentlySelectedRow!)")
                cell.detailTextLabel!.text = "additional text"
            }
        }
        
        
        //displays the food name and distance number
        cell.textLabel.text = String(format: "%@ %0.2fm", candy.name, distance.number!)
        //background color
        if distance.number >= 15 {
            
            // cell.backgroundColor = UIColor.redColor()
        }
        if distance.number <= 10 {
            
            //     cell.backgroundColor = UIColor.yellowColor()
        }
        if distance.number <= 5 {
            
            //    cell.backgroundColor = UIColor.greenColor()
        }
        
        switch candy.name {
        case "Pizza":
            cell.imageView.image = UIImage(named: "PizzaIcon")
        case "Burger":
            cell.imageView.image = UIImage(named: "BurgerIcon")
        case "Cheese Steak":
            cell.imageView.image = UIImage(named: "CheeseSteakIcon")
        default:
            cell.imageView.image = UIImage(named: "PastaIcon")
        }
        
        /* switch bright.colour {
        case "Green":
        cell.imageView.image = UIImage(name: "green-circle-md(1)")
        case "Red":
        cell.imageView.image = UIImage(name: "red-circle-md")
        } */
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        currentlySelectedRow = indexPath.row
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadData()
    }
    
    
    
    
}
