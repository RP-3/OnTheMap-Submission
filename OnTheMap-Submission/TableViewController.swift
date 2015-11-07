//
//  TableViewController.swift
//  OnTheMap-Submission
//
//  Created by Rohan Sarith Pethiyagoda on 10/10/2015.
//  Copyright © 2015 RP3. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let parse = Parse.sharedInstance()
    let udacity = Udacity.sharedInstance()
    
    var studentData:[Parse.StudentInformation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentData()
    }
    
    func getStudentData() {
        parse.getStudentLocations() { (data, error) -> Void in
            if (error != nil){
                //dispatch async so we don't modify anything from the background thread in which the callback will be invoked
                dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: "Error downloading student data.", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Aw shucks!", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            }
            
            //if any data was returned
            if let d = data{
                //sort data by updated date
                self.studentData = d.sort({$0.updatedAt!.timeIntervalSinceNow > $1.updatedAt!.timeIntervalSinceNow})
            }
            
            //add annotations from main queue
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
            
        }
    }
    
    @IBAction func refreshData(sender: AnyObject) {
        getStudentData()
    }
    
    @IBAction func logout(sender: AnyObject) {
        udacity.logout(){() -> Void in
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func updateInformation(sender: AnyObject) {
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InformationViewController")
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "student"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier)
        
        if(cell == nil){
            cell = UITableViewCell()
        }
        
        /* Set cell defaults */
        let currentStudent = studentData[indexPath.row]
        cell!.textLabel!.text = currentStudent.firstName! + " " + currentStudent.lastName!
        
        return cell!
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentData.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let student = studentData[indexPath.row]

        if let url = student.mediaURL{
            //link provided
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: url)!)
            
        }else{
            //student hasn't given us a link
            let alertController = UIAlertController(title: student.firstName! + " hasn't provided a link.", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Aw shucks!", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }

    }

}