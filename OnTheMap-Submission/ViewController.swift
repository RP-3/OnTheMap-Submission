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
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    let udacity = Udacity.sharedInstance()
    
    @IBAction func loginAction(sender: AnyObject) {
        udacity.login(emailOutlet.text!, password: passwordOutlet.text!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up backgound color
        let background = CAGradientLayer().udacityOrange()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
        //format text inputs
        emailOutlet.borderStyle = UITextBorderStyle.RoundedRect
        passwordOutlet.borderStyle = UITextBorderStyle.RoundedRect
        
        //format login button
        loginButtonOutlet.backgroundColor = UIColor(red: 241/255, green: 86/255, blue: 29/255, alpha: 1)
        loginButtonOutlet.layer.cornerRadius = 5
        
    }



}

