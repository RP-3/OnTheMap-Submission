//
//  StudentInformationModel.swift
//  OnTheMap-Submission
//
//  Created by Rohan Sarith Pethiyagoda on 12/11/2015.
//  Copyright © 2015 RP3. All rights reserved.
//

import Foundation

class StudentInformationModel {

    var studentData:[StudentInformation]? = nil
    
    //keep student data sorted
    func setStudentData(newData:[StudentInformation]){
        studentData = newData.sort({$0.updatedAt!.timeIntervalSinceNow > $1.updatedAt!.timeIntervalSinceNow})
    }
    
    func getStudentData()->[StudentInformation]?{
        return studentData
    }
    
    func getStudentInfo(studentId: String)->StudentInformation? {
        
        if(studentData == nil){
            return nil
        }
        
        //check if studentId exists in studentData array
        for student in studentData! {
            if (student.uniqueKey == studentId){
                return student
            }
        }
        
        return nil
    }
    
    class func sharedInstance() -> StudentInformationModel {
        
        struct Singleton {
            static var sharedInstance = StudentInformationModel()
        }
        
        return Singleton.sharedInstance
    }
    
}