//
//  ViewController.swift
//  OnTheMap-Submission
//
//  Created by Rohan Sarith Pethiyagoda on 8/09/2015.
//  Copyright (c) 2015 RP3. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let parse = Parse.sharedInstance()
    let udacity = Udacity.sharedInstance()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
        
        getStudentData()
    
    }
    
    func getStudentData(){
        
        parse.getStudentLocations() { (data, error) -> Void in
            if (error != nil){
                //dispatch async so we don't modify anything from the background thread in which the callback will be invoked
                dispatch_async(dispatch_get_main_queue(), {
                    
                    let alertController = UIAlertController(title: "Error downloading student data.", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Aw shucks!", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            }else{
                
                var studentPinsArray: Array<StudentPin> = []
                
                for student in data! {
                    let studentName = student.firstName! + " " + student.lastName!
                    let studentCoord = CLLocationCoordinate2D(latitude: student.latitude!, longitude: student.longitude!)
                    let studentSubtitle = student.mediaURL!
                    
                    let newStudentPin = StudentPin(title: studentName, subtitle: studentSubtitle, coordinate: studentCoord)
                    studentPinsArray.append(newStudentPin)
                }
                
                //add annotations from main queue
                dispatch_async(dispatch_get_main_queue(), {
                    
                    //remove all existing annotations
                    let annotationsToRemove = self.mapView.annotations.filter { _ in return true }
                    self.mapView.removeAnnotations( annotationsToRemove )
                    
                    //add the new ones
                    self.mapView.addAnnotations(studentPinsArray)
                })
            }
            
        }
    }
    
    @IBAction func refreshData(sender: AnyObject) {
        getStudentData()
    }
    
    
    @IBAction func logout(sender: AnyObject) {
        udacity.logout(){() -> Void in
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    @IBAction func updateDetails(sender: AnyObject) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InformationViewController")
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    // addAnnotation delegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView

        if pinView == nil {
            let studentAnnotation = annotation as! StudentPin
            pinView = MKPinAnnotationView(annotation: studentAnnotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }else{
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // Respond to taps
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation!.subtitle!!)!)
        }
    }
    
    
}

