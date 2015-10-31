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
import WebKit
import CoreLocation

class InformationViewController: UIViewController, MKMapViewDelegate, WKNavigationDelegate, UITextFieldDelegate {
    
    let parse = Parse.sharedInstance()
    let udacity = Udacity.sharedInstance()
    
    let geoCoder = CLGeocoder()
    
    var reqBody: [String: AnyObject] = [
        "firstName": "",
        "lastName": "",
        "mapString": "",
        "mediaURL": "",
        "uniqueKey": "",
        "latitude": "",
        "longitude": ""
    ]
    
    var webView: WKWebView!

    @IBOutlet weak var questionBox: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var questionLabel: UILabel!

    @IBAction func cancelUpdateModal(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if(submitButton.titleLabel?.text == "Confirm Location"){
            submitButton.setTitle("Find on Map", forState: UIControlState.Normal)   
        }else if(submitButton.titleLabel?.text == "Confirm URL"){
            submitButton.setTitle("Go to URL", forState: UIControlState.Normal)
        }
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(submitButton.titleLabel?.text == "Confirm URL"){
            submitButton.setTitle("Go to URL", forState: UIControlState.Normal)
        }
        
        return true
    }
    
    @IBAction func submitLocation(sender: AnyObject) {
        
        if(submitButton.titleLabel?.text == "Confirm URL"){
            //if sending the request
            let userId = reqBody["uniqueKey"] as! String
            reqBody["mediaURL"] = locationInput.text
            
            parse.upsertStudentData(userId, studentUpdate: reqBody){ (error) -> Void in
                
                let msg = error == nil ? "Update Successful." : "Error updating data."

                dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: msg, message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "Back", style: UIAlertActionStyle.Default){(UIAlertAction) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    alertController.addAction(action)
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
                
            }
        }
            
        else if(submitButton.titleLabel?.text == "Go to URL"){
            
            let url = NSURL(string: locationInput.text!)!
            webView.loadRequest(NSURLRequest(URL: url))
            
            submitButton.setTitle("Confirm URL", forState: UIControlState.Normal)
            
        }
        
        else if(submitButton.titleLabel?.text == "Confirm Location"){
            //if confirming chosen location
            
            //change button to indicate next step
            self.submitButton.setTitle("Confirm URL", forState: UIControlState.Normal)
            
            //add location info to request body
            self.reqBody["latitude"] = self.mapView.region.center.latitude
            self.reqBody["longitude"] = self.mapView.region.center.longitude
            self.reqBody["mapString"] = self.locationInput.text
            
            //change the prompts for media URL input
            if reqBody["mediaURL"] as! String != "" {
                locationInput.text = reqBody["mediaURL"] as? String
            }else{
                locationInput.text = "https://www.google.com"
            }
            
            //replace mapview with webview
            mapView.removeFromSuperview()
            
            webView = WKWebView(frame: detailContainerView.frame)
            webView.center = CGPointMake(detailContainerView.frame.width/2, detailContainerView.frame.height/2)
            webView.navigationDelegate = self
            
            
            detailContainerView.addSubview(webView)
            
            let url = NSURL(string: locationInput.text!)!
            webView.loadRequest(NSURLRequest(URL: url))
            webView.allowsBackForwardNavigationGestures = true

            questionLabel.text = "Your Student Page URL?"
            
        }else{
            //if submitting a location for geocoding
            locationInput.resignFirstResponder() //dismiss the keyboard
            
            if let inputText = locationInput.text {
                
                let progressIndicator = ProgressIndicator(text: "Searching")
                self.view.addSubview(progressIndicator)
                
                geoCoder.geocodeAddressString(inputText, completionHandler: { (placemark: [CLPlacemark]?, error: NSError?) -> Void in
                    
                    progressIndicator.removeFromSuperview()
                    
                    if let returnedLocation = placemark {
                        
                        self.submitButton.setTitle("Confirm Location", forState: UIControlState.Normal)
                        
                        let pmCircularRegion = returnedLocation[0].region as! CLCircularRegion
                        let region = MKCoordinateRegionMakeWithDistance(pmCircularRegion.center, pmCircularRegion.radius, pmCircularRegion.radius)
                        
                        self.mapView.setRegion(region, animated: true)
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), {
                            let alertController = UIAlertController(title: "Couldn't find that on the map.", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.Default,handler: nil))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        })
                    }
                    
                })
                
            }
            
            //No else case. If no location was provided, ignore the request
            
        }
        
        
        
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        locationInput.text = webView.URL?.absoluteURL.absoluteString
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        let alertController = UIAlertController(title: "Invalid URL", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        submitButton.setTitle("Go to URL", forState: UIControlState.Normal)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let studentId = udacity.getSession()["key"]!
        
        reqBody["uniqueKey"] = studentId
        reqBody["firstName"] = udacity.getUserData()["firstName"]!
        reqBody["lastName"] = udacity.getUserData()["lastName"]!
            
        if let userParseData = parse.getStudentInfo(studentId!) {
            reqBody["mapString"] = userParseData.mapString!
            reqBody["mediaURL"] = userParseData.mediaURL!
        }
        
        locationInput.placeholder = reqBody["mapString"] as? String
            
        questionBox.backgroundColor = UIColor(red: (81/255.0), green: (137/255.0), blue: (180/255.0), alpha: 1)
        submitButton.backgroundColor = UIColor(red: (253/255.0), green: (151/255.0), blue: (42/255.0), alpha: 1)
        submitButton.layer.cornerRadius = 5
        
        locationInput.delegate = self
        
    }
    
}