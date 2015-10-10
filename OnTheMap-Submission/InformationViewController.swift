//
//  InformationViewController.swift
//  OnTheMap-Submission
//
//  Created by Rohan Sarith Pethiyagoda on 10/10/2015.
//  Copyright © 2015 RP3. All rights reserved.
//

import Foundation
import UIKit

class InformationViewController: UIViewController {

    @IBOutlet weak var questionBox: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var locationInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionBox.backgroundColor = UIColor(red: (81/255.0), green: (137/255.0), blue: (180/255.0), alpha: 1)
        
        
    }
    
}