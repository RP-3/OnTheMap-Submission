//
//  ParseClient.swift
//  OnTheMap-Submission
//
//  Created by Rohan Sarith Pethiyagoda on 28/09/2015.
//  Copyright © 2015 RP3. All rights reserved.
//

import Foundation
import CoreLocation

class Parse {
    
    let request = Request.sharedInstance()
    let baseURL = "https://api.parse.com/1/classes/"
    
    let reqHeaders = [
        "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
        "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    ]
    
    var studentData:[StudentInformation]? = nil
    
    struct StudentInformation {
        var createdAt: NSDate?
        var firstName: String?
        var lastName: String?
        var latitude: Double?
        var longitude: Double?
        var mapString: String?
        var mediaURL: String?
        var objectId: String?
        var uniqueKey: String?
        var updatedAt: NSDate?
        
        init (dict: NSDictionary) {
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let createdDateString = (dict["createdAt"] as AnyObject? as? String?)!
            let updatedDateString = (dict["updatedAt"] as AnyObject? as? String?)!
            
            createdAt = formatter.dateFromString(createdDateString!)
            updatedAt = formatter.dateFromString(updatedDateString!)
            firstName = (dict["firstName"] as AnyObject? as? String?)!
            lastName = (dict["lastName"] as AnyObject? as? String?)!
            latitude = (dict["latitude"]  as AnyObject? as? Double?)!
            longitude = (dict["longitude"]  as AnyObject? as? Double?)!
            mapString = (dict["mapString"] as AnyObject? as? String?)!
            mediaURL = (dict["mediaURL"] as AnyObject? as? String?)!
            objectId = (dict["objectId"] as AnyObject? as? String?)!
            uniqueKey = (dict["uniqueKey"]  as AnyObject? as? String?)!

        }
    }
    
    func parseStudentData(data: [NSDictionary]) -> [StudentInformation]{
        
        var result: Array<StudentInformation> = []
        
        for dict in data {
            let s:StudentInformation = StudentInformation(dict: dict)
            result.append(s)
        }
        
        return result
        
    }
    
    func getStudentLocations(callback: ((data: [StudentInformation]?, error: String?) -> Void)) {
        
        let url = baseURL + "StudentLocation"
        
        request.GET(url, headers: reqHeaders, isUdacity: false) { (data, response, error) -> Void in
            
            //TODO: Handle connection error
            if error != nil {
                callback(data: nil, error: error?.description)
                return
            }
            
            //handle user error
            let httpResponse = response as! NSHTTPURLResponse
            if(httpResponse.statusCode > 399 && httpResponse.statusCode < 500){
                callback(data: nil, error: "Invalid login credentials")
                return
            }
            
            let arrayObjs = data as! [String: AnyObject]
            let arrayDicts = (arrayObjs["results"]! as? [NSDictionary])
            self.studentData = self.parseStudentData(arrayDicts!)
            
            //return session data to login view controller (not used: just as a courtesy)
            callback(data: self.studentData, error: nil)
            return
        }
        
    }
    
    func upsertStudentData(studentId: String, studentUpdate: [String: AnyObject], callback: ((error: String?) -> Void)) {
        
        //check student data has loaded
        if(studentData == nil){
            callback(error: "Student Data not yet loaded")
            return
        }
        
        //check if studentId exists in studentData array
        var alreadyPosted: Bool = false
        
        for student in studentData! {
            if (student.uniqueKey == studentId){
                alreadyPosted = true
            }
        }
        
        if(alreadyPosted == false){
            //POST to update the existing value
            let url = baseURL + "StudentLocation"
            
            request.POST(url, headers: reqHeaders, body: studentUpdate, isUdacity: false) { (data, response, error) -> Void in
                
                //handle connection error
                if error != nil {
                    callback(error: error?.description)
                    return
                }
                
                //handle user error
                let httpResponse = response as! NSHTTPURLResponse
                if(httpResponse.statusCode > 399 && httpResponse.statusCode < 500){
                    callback(error: "Access denied")
                    return
                }
                
                //no errors!
                callback(error: nil)
                return
                
            }
            
        }else{
            //PUT to create a new value
            
            
        }
        
    }
    
    class func sharedInstance() -> Parse {
        
        struct Singleton {
            static var sharedInstance = Parse()
        }
        
        return Singleton.sharedInstance
    }
    
}