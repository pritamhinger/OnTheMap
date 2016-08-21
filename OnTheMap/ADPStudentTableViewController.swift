//
//  ADPStudentTableViewController.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 15/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class ADPStudentTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    //private var students:[Student]?
    var currentStudent:Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ADPStudentTableViewController.initiateGetRequestOnSortParameterChange(_:)), name: ParseClient.NotificationName.SortParameterChangeNotificationForTable, object: nil)
        
        if AppData.sharedInstance.students?.count > 0{
            //self.students  = result
            self.tableView.reloadData()
        }
        else{
            ParseClient.sharedInstance().getEnrolledStudents(){ (results, error) in
                if error == nil{
                    performUIUpdatesOnMain{
                        self.tableView.reloadData();
                    }
                }
                else{
                    performUIUpdatesOnMain{
                        let errorMessage = ParseClient.sharedInstance().extractUserFriendlyErrorMessage(error!)
                        ParseClient.sharedInstance().showError(self, message: errorMessage, title: "On The Map", style: .Alert)
                    }
                }
            }
        }
    }

    // MARK: - IBActions
    @IBAction func refresh(sender: UIBarButtonItem) {
        getStudents()
    }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        ParseClient.sharedInstance().logoutFromUdacity{(results, error) in
            if error == nil{
                performUIUpdatesOnMain{
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            else{
                performUIUpdatesOnMain{
                    let errorMessage = ParseClient.sharedInstance().extractUserFriendlyErrorMessage(error!)
                    ParseClient.sharedInstance().showError(self, message: errorMessage, title: "On The Map", style: .Alert)
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let students = AppData.sharedInstance.students{
            return students.count
        }
        else{
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ParseClient.CellIdentifier.StudentCell, forIndexPath: indexPath) as! ADPStudentTableViewCell

        let student = AppData.sharedInstance.students![indexPath.row]
        cell.studentName.text = "\((student.firstName)) \((student.lastName))"
        cell.mediaURL.text = student.mediaURL
        cell.createdDate.text = getFormattedDate((student.createdAt))
        cell.updatedDate.text = getFormattedDate((student.updatedAt))
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ADPStudentTableViewCell
        if let url = NSURL(string: cell.mediaURL!.text!){
            if(UIApplication.sharedApplication().canOpenURL(url)){
                UIApplication.sharedApplication().openURL(url)
            }
            else{
                ParseClient.sharedInstance().showError(self, message: "Invalid Media URL. Operation can't be continued", title: "Open URL in browser", style: .Alert)
            }
        }
        else{
            ParseClient.sharedInstance().showError(self, message: "Invalid Media URL. Operation can't be continued", title: "Open URL in browser", style: .Alert)
        }
    }
    
    
    @IBAction func showNewStudentForm(sender: AnyObject) {
        ParseClient.sharedInstance().checkUserRecord(self){ (student, update, error) in
            if error == nil {
                if update{
                    self.currentStudent = student
                }
                else{
                    return
                }
            }
            else{
                if error?.domain == "Student Information"{
                    self.currentStudent = nil
                }
                else{
                    let errorMessage = ParseClient.sharedInstance().extractUserFriendlyErrorMessage(error!)
                    performUIUpdatesOnMain{
                        ParseClient.sharedInstance().showError(self, message: errorMessage, title: "On The Map", style: .Alert)
                    }
                    
                    return
                }
                
            }
            
            self.performSegueWithIdentifier("newRecordSegueFromTable", sender: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "sortSegueFromTable"){
            let controller = segue.destinationViewController as! ADPSortViewController
            controller.modalPresentationStyle = UIModalPresentationStyle.Popover
            controller.popoverPresentationController?.delegate = self
            controller.notificationName = ParseClient.NotificationName.SortParameterChangeNotificationForTable
        }
        else if segue.identifier == "newRecordSegueFromTable"{
            let controller = segue.destinationViewController as! ADPNewRecordViewController
            controller.student = currentStudent
        }
    }
 

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    // MARK: - Private Methods
    func getFormattedDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter.stringFromDate(date);
    }
    
    // MARK: - NSNotification Handler
    func initiateGetRequestOnSortParameterChange(notification:NSNotification){
        getStudents()
    }
    
    func getStudents() {
        ParseClient.sharedInstance().getEnrolledStudents(){ (results, error) in
            if error == nil{
                performUIUpdatesOnMain{
                    self.tableView.reloadData()
                }
            }
            else{
                performUIUpdatesOnMain{
                    let errorMessage = ParseClient.sharedInstance().extractUserFriendlyErrorMessage(error!)
                    ParseClient.sharedInstance().showError(self, message: errorMessage, title: "On The Map", style: .Alert)
                }
            }
        }
    }
}
