//
//  InformationViewController.swift
//  OnTheMap-Submission
//
//  Created by Rohan Sarith Pethiyagoda on 10/10/2015.
//  Copyright © 2015 RP3. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class InformationViewController: UIViewController, MKMapViewDelegate {
    
    let parse = Parse.sharedInstance()
    let udacity = Udacity.sharedInstance()
    
    let geoCoder = CLGeocoder()

    @IBOutlet weak var questionBox: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!

    @IBAction func cancelUpdateModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func submitLocation(sender: AnyObject) {
        
        if(submitButton.titleLabel?.text == "Confirm"){
            //if confirming chosen location
            
            let lat = self.mapView.region.center.latitude
            let long = self.mapView.region.center.longitude
            let userId = udacity.getSession()["key"]!
            
            let reqBody: [String: AnyObject] = [
                "firstName": "RP",
                "lastName": "3",
                "mapString": "San Francisco, CA",
                "mediaURL": "https://www.linkedin.com/in/rpiii",
                "uniqueKey": userId!,
                "latitude": lat,
                "longitude": long
            ]
            
            parse.upsertStudentData(userId!, studentUpdate: reqBody){ (error) -> Void in
                print("Error")
                print(error)
            }
            
        }else{
            //if submitting a location for geocoding
            if let inputText = locationInput.text {
                
                geoCoder.geocodeAddressString(inputText, completionHandler: { (placemark: [CLPlacemark]?, error: NSError?) -> Void in
                    
                    if let returnedLocation = placemark {
                        
                        self.submitButton.setTitle("Confirm", forState: UIControlState.Normal)
                        
                        let pmCircularRegion = returnedLocation[0].region as! CLCircularRegion
                        let region = MKCoordinateRegionMakeWithDistance(pmCircularRegion.center, pmCircularRegion.radius, pmCircularRegion.radius)
                        
                        self.mapView.setRegion(region, animated: true)
                        
                    }else{
                        //present error modally
                    }
                    
                    print(error)
                    
                })
                
            }
            
            //No else case. If no location was provided, ignore the request
            
        }
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionBox.backgroundColor = UIColor(red: (81/255.0), green: (137/255.0), blue: (180/255.0), alpha: 1)
        submitButton.backgroundColor = UIColor(red: (253/255.0), green: (151/255.0), blue: (42/255.0), alpha: 1)
        submitButton.layer.cornerRadius = 5
        
        if let userId = udacity.getSession()["key"]! {

            let reqBody: [String: AnyObject] = [
                "firstName": "RP",
                "lastName": "3",
                "mapString": "San Francisco, CA",
                "mediaURL": "https://www.linkedin.com/in/rpiii",
                "uniqueKey": userId,
                "latitude": 37.780977,
                "longitude": -122.410206
            ]
            
            parse.upsertStudentData(userId, studentUpdate: reqBody){ (error) -> Void in
                print("Error")
                print(error)
            }

        }
        
        
        
    }
    
}