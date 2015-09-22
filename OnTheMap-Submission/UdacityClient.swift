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
    
    func login(username: String, password: String){

        let url = baseURL + "session"
        
        let reqBody = [
            "udacity" : [
                "username": username,
                "password": password
            ]
        ]
        
        request.POST(url, body: reqBody, isUdacity:true) { (data, response, error) -> Void in
            if error != nil { // Handle error…
                print("RP3! Error!")
                print(error)
                return
            }
            
            print("RP3! Data!")
            print(data)
        }

    }
    
    func parseUdacityData(data:NSData) ->NSData{
        return data.subdataWithRange(NSMakeRange(5, data.length - 5)) // subset response data
    }
    
    class func sharedInstance() -> Udacity {
        
        struct Singleton {
            static var sharedInstance = Udacity()
        }
        
        return Singleton.sharedInstance
    }
    
}