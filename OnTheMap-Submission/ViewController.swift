//
//  ViewController.swift
//  OnTheMap-Submission
//
//  Created by Rohan Sarith Pethiyagoda on 8/09/2015.
//  Copyright (c) 2015 RP3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var udacityImageOutlet: UIImageView!
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up backgound color
        let background = CAGradientLayer().udacityOrange()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
        //format text inputs
        var frameRect = emailOutlet.frame
        frameRect.size.height = 100
        emailOutlet.frame = frameRect
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

