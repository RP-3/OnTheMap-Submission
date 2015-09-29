//
//  ParseClient.swift
//  OnTheMap-Submission
//
//  Created by Rohan Sarith Pethiyagoda on 28/09/2015.
//  Copyright © 2015 RP3. All rights reserved.
//

import Foundation

class Parse {
    
    let request = Request.sharedInstance()
    let baseURL = "https://api.parse.com/1/classes/"
    
    let reqHeaders = [
        "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
        "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    ]
    
    struct StudentData {
        var createdAt: String?
        var firstName: String?
        var lastName: String?
        var latitude: Float32?
        var longitude: Float32?
        var mapString: String?
        var mediaURL: String?
        var objectId: String?
        var uniqueKey: String?
        var updatedAt: String?
    }
    
    func parseStudentData(data: [NSDictionary]) -> [StudentData]{
        
        var result: Array<StudentData> = []
        
        for dict in data {
            
            var s:StudentData = StudentData()
            
            s.createdAt = (dict["createdAt"] as AnyObject? as? String?)!
            s.firstName = (dict["firstName"] as AnyObject? as? String?)!
            s.lastName = (dict["lastName"] as AnyObject? as? String?)!
            s.latitude = (dict["latitude"]  as AnyObject? as? Float32?)!
            s.longitude = (dict["longitude"]  as AnyObject? as? Float32?)!
            s.mapString = (dict["mapString"] as AnyObject? as? String?)!
            s.mediaURL = (dict["mediaURL"] as AnyObject? as? String?)!
            s.objectId = (dict["objectId"] as AnyObject? as? String?)!
            s.uniqueKey = (dict["uniqueKey"]  as AnyObject? as? String?)!
            s.updatedAt = (dict["updatedAt"] as AnyObject? as? String?)!

            result.append(s)
            
        }
        
        return result
        
    }
    
    func getStudentLocations(callback: ((data: [StudentData]?, error: String?) -> Void)) {
        
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
            let result = self.parseStudentData(arrayDicts!)
            
            //return session data to login view controller (not used: just as a courtesy)
            callback(data: result, error: nil)
            return
        }
        
    }
    
    class func sharedInstance() -> Parse {
        
        struct Singleton {
            static var sharedInstance = Parse()
        }
        
        return Singleton.sharedInstance
    }
    
}