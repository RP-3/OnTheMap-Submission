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
    
    func GET(url: String, headers: [String: String]?, isUdacity: BooleanLiteralType, callback: ((data: AnyObject?, response: NSURLResponse?, error: NSError?) -> Void)?) {
        let request = makeRequest(url, method: "GET", body: nil, headers: headers)
        let task = session.dataTaskWithRequest(request) {downloadData, downloadResponse, downloadError in
            self.parseJSONWithCompletionHandler(downloadData, response: downloadResponse, error: downloadError, isUdacity: isUdacity, completionHandler: callback!)
        }
        task.resume()
    }
    
    func POST(url: String, headers: [String: String]?, body: [String : AnyObject], isUdacity: BooleanLiteralType, callback: ((data: AnyObject?, response: NSURLResponse?, error: NSError?) -> Void)?) {
        let request = makeRequest(url, method: "POST", body: body, headers: nil)
        let task = session.dataTaskWithRequest(request) {downloadData, downloadResponse, downloadError in
            self.parseJSONWithCompletionHandler(downloadData, response: downloadResponse, error: downloadError, isUdacity: isUdacity, completionHandler: callback!)
        }
        task.resume()
    }
    
    func PUT(url: String, body: [String : AnyObject], callback: ((data: NSData?, response: NSURLResponse?, error: NSError?) -> Void)?) {
//        let request = makeRequest(url, method: "PUT", body: nil)
//        let task = session.dataTaskWithRequest(request, completionHandler: completionHandler!)
//        task.resume()
    }
    
    func DELETE(url: String, body: [String : AnyObject], callback: ((data: NSData?, response: NSURLResponse?, error: NSError?) -> Void)?){
//        let request = makeRequest(url, method: "DELETE", body: nil)
//        let task = session.dataTaskWithRequest(request, completionHandler: completionHandler!)
//        task.resume()
    }
    
    func parseUdacityData(data:NSData) ->NSData{
        return data.subdataWithRange(NSMakeRange(5, data.length - 5)) // subset response data
    }
    
    func makeRequest(url:String, method: String, body: [String : AnyObject]?, headers: [String: String]?) -> NSMutableURLRequest {
    
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let headerDictionary = headers {
            for (header, value) in headerDictionary {
                request.addValue(value, forHTTPHeaderField: header)
            }
        }
        
        if let requestBodyDictionary = body {
            
            let serealisedBody: NSData?
            do {
                serealisedBody = try NSJSONSerialization.dataWithJSONObject(requestBodyDictionary, options: [])
            } catch let error as NSError {
                print(error)
                serealisedBody = nil
            }
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
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    func parseJSONWithCompletionHandler(data: NSData?, response: NSURLResponse?, error: NSError?, isUdacity: BooleanLiteralType, completionHandler: (data: AnyObject?, result: NSURLResponse?, error: NSError?) -> Void) {

        //handle error in connection case
        if(error != nil){
            completionHandler(data: nil, result: nil, error: error!)
            return
        }
        
        var preparsedData = data
        let parsedResult: AnyObject?
        
        if(isUdacity){
            preparsedData = parseUdacityData(preparsedData!)
        }
        
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(preparsedData!, options: NSJSONReadingOptions.AllowFragments) 
        } catch let error as NSError {
            //handle error in parsing case
            print("Error in parsing case.")
            completionHandler(data: nil, result: nil, error: error)
            return
        }

        completionHandler(data: parsedResult, result: response!, error: nil)
        
    }
    
}