//
//  CAGradientLayer+Convenience.swift
//  OnTheMap-Submission
//
//  Created by Rohan Sarith Pethiyagoda on 8/09/2015.
//  Copyright (c) 2015 RP3. All rights reserved.
//

import UIKit

extension CAGradientLayer {
   
    func udacityOrange() -> CAGradientLayer {
        
        let topColor = UIColor(red: (253/255.0), green: (151/255.0), blue: (42/255.0), alpha: 1)
        let bottomColor = UIColor(red: (252/255.0), green: (111/255.0), blue: (34/255.0), alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
        
    }
    
}
