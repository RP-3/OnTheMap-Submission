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
    
    func login(username: String, password: String, completionHandler: (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void){

        let url = baseURL + "session"
        
        let reqBody = [
            "udacity" : [
                "username": username,
                "password": password
            ]
        ]
        
        request.POST(url, body: reqBody) { (data, response, error) -> Void in
            if(data != nil){
                let newData = self.parseUdacityData(data)
                completionHandler(data: newData, response: response, error: error)
            }else{
                completionHandler(data: data, response: response, error: error)
            }
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
