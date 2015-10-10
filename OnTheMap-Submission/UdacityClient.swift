//
//  UdacityClient.swift
//  OnTheMap-Submission
//
//  Created by Rohan Sarith Pethiyagoda on 15/09/2015.
//  Copyright (c) 2015 RP3. All rights reserved.
//

import Foundation

class Udacity {
    
    let request = Request.sharedInstance()
    let baseURL = "https://www.udacity.com/api/"
    
    var session: [String: String?] = [
        "key": nil,
        "sessionId": nil,
        "expiration": nil
    ]
    
    func login(username: String, password: String, callback: ((data: [String: String?]?, error: String?) -> Void)) {

        let url = baseURL + "session"
        
        let reqBody = [
            "udacity" : [
                "username": username,
                "password": password
            ]
        ]
        
        request.POST(url, headers: nil, body: reqBody, isUdacity:true) { (data, response, error) -> Void in
            
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
            
            //no errors
            //set up the session in our Udacity client
            let account = data!["account"] as! NSDictionary
            self.session["key"] = account["key"]! as? String
            
            let dataSession = data!["session"] as! NSDictionary
            self.session["sessionId"] = dataSession["id"] as? String
            self.session["expiration"] = dataSession["expiration"] as? String
            
            //return session data to login view controller (not used: just as a courtesy)
            callback(data: self.session, error: nil)
            return
        }

    }
    
    func logout(callback: (() -> Void)) {
        session["key"] = nil
        session["sessionId"] = nil
        session["expiration"] = nil
        callback()
    }
    
    class func sharedInstance() -> Udacity {
        
        struct Singleton {
            static var sharedInstance = Udacity()
        }
        
        return Singleton.sharedInstance
    }
    
}