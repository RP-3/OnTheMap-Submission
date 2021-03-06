//
//  ViewController.swift
//  OnTheMap-Submission
//
//  Created by Rohan Sarith Pethiyagoda on 8/09/2015.
//  Copyright (c) 2015 RP3. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var udacityImageOutlet: UIImageView!
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    let udacity = Udacity.sharedInstance()
    
    @IBAction func loginAction(sender: AnyObject) {
        
        let progressIndicator = ProgressIndicator(text: "Logging in")
        self.view.addSubview(progressIndicator)
        
        udacity.login(emailOutlet.text!, password: passwordOutlet.text!) { (data, error) -> Void in
            
            //display error to user
            if error != nil {
                //dispatch async so we don't modify anything from the background thread in which the callback will be invoked
                dispatch_async(dispatch_get_main_queue(), {
                    
                    progressIndicator.removeFromSuperview() //remove progress indicator
                    
                    let animation = CABasicAnimation(keyPath: "position")
                    animation.duration = 0.07
                    animation.repeatCount = 4
                    animation.autoreverses = true
                    animation.fromValue = NSValue(CGPoint: CGPointMake(self.view.center.x - 10, self.view.center.y))
                    animation.toValue = NSValue(CGPoint: CGPointMake(self.view.center.x + 10, self.view.center.y))
                    self.view.layer.addAnimation(animation, forKey: "position")
                    
                    let alertController = UIAlertController(title: "Something wong", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Darn it...", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
                
            }else{
            //transition tab bar controller
                
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AuthenticatedAppController") as! UITabBarController
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    progressIndicator.removeFromSuperview()
                    self.presentViewController(controller, animated: true, completion: nil)
                }
                

            }
            
        }
        
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

