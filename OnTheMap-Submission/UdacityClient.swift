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
    
    var user: [String: String?] = [
        "firstName": nil,
        "lastName": nil
    ]
    
    func _getUserData(userId: String){
        let url = baseURL + "users/" + userId
        
        request.GET(url, headers: nil, isUdacity: true) { (data, response, error) -> Void in
            
            //Handle connection error
            if error != nil {
                return
            }
            
            //handle user error
            let httpResponse = response as! NSHTTPURLResponse
            if(httpResponse.statusCode > 399 && httpResponse.statusCode < 500){
                return
            }
            
            //save public user info
            let firstName = data!["user"]!!["first_name"] as! String
            let lastName = data!["user"]!!["last_name"] as! String
            
            self.user["firstName"] = firstName
            self.user["lastName"] = lastName

        }

    }
    
    func getUserData() -> [String: String?]{
        return self.user
    }
    
    func login(username: String, password: String, callback: ((data: [String: String?]?, error: String?) -> Void)) {

        let url = baseURL + "session"
        
        let reqBody = [
            "udacity" : [
                "username": username,
                "password": password
            ]
        ]
        
        request.POST(url, headers: nil, body: reqBody, isUdacity:true) { (data, response, error) -> Void in
            
            //Handle connection error
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
            
            self._getUserData((account["key"]! as? String)!)
            
            //return session data to login view controller (not used: just as a courtesy)
            callback(data: self.session, error: nil)
            return
        }

    }
    
    func getSession()->[String:String?]{
        return self.session
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