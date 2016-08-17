//
//  ADPStudentTableViewController.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 15/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class ADPStudentTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    private var students:[Student]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let result = (UIApplication.sharedApplication().delegate as! AppDelegate).students{
            self.students  = result
            self.tableView.reloadData()
        }
        else{
            ParseClient.sharedInstance().getEnrolledStudents(){ (results, error) in
                if error == nil{
                    performUIUpdatesOnMain{
                        self.students = results
                        (UIApplication.sharedApplication().delegate as! AppDelegate).students = results
                        self.tableView.reloadData();
                    }
                }
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let students = students{
            return students.count
        }
        else{
            return 0;
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ParseClient.CellIdentifier.StudentCell, forIndexPath: indexPath) as! ADPStudentTableViewCell

        let student = students?[indexPath.row];
        cell.studentName.text = "\((student?.firstName)!) \((student?.lastName)!)"
        cell.mediaURL.text = student?.mediaURL
        cell.createdDate.text = getFormattedDate((student?.createdAt)!)
        cell.updatedDate.text = getFormattedDate((student?.updatedAt)!)
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "sortSegueFromTable"){
            let controller = segue.destinationViewController as! ADPSortViewController
            controller.modalPresentationStyle = UIModalPresentationStyle.Popover
            controller.popoverPresentationController?.delegate = self
        }
    }
 

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    // MARK: - Private Methods
    func getFormattedDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss";
        return dateFormatter.stringFromDate(date);
    }
}
