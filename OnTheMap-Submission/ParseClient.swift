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
    
    func getStudentLocations(callback: ((data: [String: String?]?, error: String?) -> Void)) {
        
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
            
            //no errors: parse data
            print(data)
            
            //return session data to login view controller (not used: just as a courtesy)
            //callback(data: self.session, error: nil)
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