//
//  StudentInformation.swift
//  OnTheMap-Submission
//
//  Created by Rohan Sarith Pethiyagoda on 10/10/2015.
//  Copyright © 2015 RP3. All rights reserved.
//

import Foundation
import MapKit

class StudentPin: NSObject, MKAnnotation {
    
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        super.init()
    }
    
    
}