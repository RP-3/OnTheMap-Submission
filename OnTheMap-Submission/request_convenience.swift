//
//  request_convenience.swift
//  OnTheMap-Submission
//
//  Created by Rohan Sarith Pethiyagoda on 15/09/2015.
//  Copyright (c) 2015 RP3. All rights reserved.
//

import Foundation

import UIKit

class Request : NSObject {
    
    /* Shared session */
    var session: NSURLSession
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : Int? = nil
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func GET(url: String, completionHandler: ((data: NSData!, response: NSURLResponse!, error: NSError!) -> Void)?) {
        let request = makeRequest(url, method: "GET", body: nil)
        let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
        task.resume()
    }
    
    func POST(url: String, body: [String : AnyObject], completionHandler: ((data: NSData!, response: NSURLResponse!, error: NSError!) -> Void)?) {
        let request = makeRequest(url, method: "POST", body: body)
        let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
        task.resume()
    }
    
    func PUT(url: String, body: [String : AnyObject], completionHandler: ((data: NSData!, response: NSURLResponse!, error: NSError!) -> Void)?) {
        let request = makeRequest(url, method: "PUT", body: nil)
        let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
        task.resume()
    }
    
    func DELETE(url: String, body: [String : AnyObject], completionHandler: ((data: NSData!, response: NSURLResponse!, error: NSError!) -> Void)?) {
        let request = makeRequest(url, method: "DELETE", body: nil)
        let task = session.dataTaskWithRequest(request, completionHandler: completionHandler)
        task.resume()
    }
    
    
    func makeRequest(url:String, method: String, body: [String : AnyObject]?) -> NSMutableURLRequest {
    
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let requestBodyDictionary = body {
            
            var err:NSError?
            let serealisedBody =  NSJSONSerialization.dataWithJSONObject(requestBodyDictionary, options: nil, error: &err)
            request.HTTPBody = serealisedBody
            
        }
        
        return request

    }
    
    class func sharedInstance() -> Request {
        
        struct Singleton {
            static var sharedInstance = Request()
        }
        
        return Singleton.sharedInstance
    }
    
    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
}