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
    let studentDataModel = StudentInformationModel.sharedInstance()
    let baseURL = "https://api.parse.com/1/classes/"
    
    let reqHeaders = [
        "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
        "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    ]
    
    func parseStudentData(data: [NSDictionary]) -> [StudentInformation]{
        
        var result: Array<StudentInformation> = []
        
        for dict in data {
            let s:StudentInformation = StudentInformation(dict: dict)
            result.append(s)
        }
        
        return result
        
    }
    
    func getStudentLocations(callback: ((error: String?) -> Void)) {
        
        let url = baseURL + "StudentLocation"
        
        request.GET(url, headers: reqHeaders, isUdacity: false) { (data, response, error) -> Void in
            
            //TODO: Handle connection error
            if error != nil {
                callback(error: error?.description)
                return
            }
            
            //handle user error
            let httpResponse = response as! NSHTTPURLResponse
            if(httpResponse.statusCode > 399 && httpResponse.statusCode < 500){
                callback(error: "Invalid login credentials")
                return
            }
            
            let arrayObjs = data as! [String: AnyObject]
            let arrayDicts = (arrayObjs["results"]! as? [NSDictionary])
            self.studentDataModel.setStudentData(self.parseStudentData(arrayDicts!))
            
            //return session data to login view controller (not used: just as a courtesy)
            callback(error: nil)
            return
        }
        
    }
    
    func upsertStudentData(studentId: String, studentUpdate: [String: AnyObject], callback: ((error: String?) -> Void)) {
        
        //check student data has loaded
        if(studentDataModel.getStudentData() == nil){
            callback(error: "Student Data not yet loaded")
            return
        }
        
        //check if studentId exists in studentData array
        var alreadyPosted: Bool = false
        var objectId: String? = nil
        
        let studentData = studentDataModel.getStudentData()
        
        for student in studentData! {
            if (student.uniqueKey == studentId){
                alreadyPosted = true
                objectId = student.objectId
            }
        }
        
        if(alreadyPosted == false){
            //POST to create a new value
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
            //PUT to update an existing value
            let url = baseURL + "StudentLocation/" + objectId!
            
            request.PUT(url, headers: reqHeaders, body: studentUpdate, isUdacity: false) { (data, response, error) -> Void in
                
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

            
            
        }
        
    }
    
    class func sharedInstance() -> Parse {
        
        struct Singleton {
            static var sharedInstance = Parse()
        }
        
        return Singleton.sharedInstance
    }
    
}