//
//  ADPNewRecordViewController.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 19/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit
import MapKit

class ADPNewRecordViewController: UIViewController {

    var student:Student? = nil
    
    @IBOutlet weak var studentLocationMapView: MKMapView!
    @IBOutlet weak var locationTextBox: UITextField!
    @IBOutlet weak var submitRecordButton: UIButton!
    
    // MARK: - COntroller Life Cycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions
    @IBAction func getLatLongForLocation(sender: UIButton) {
        let location = locationTextBox.text!;
        ParseClient.sharedInstance().getLatLongForAddress(location){ (placemarks, error) in
            if error == nil {
                performUIUpdatesOnMain{
                    if placemarks?.count > 0{
                        UIView.transitionWithView(self.studentLocationMapView, duration: 1.0, options: [.CurveEaseOut, .TransitionCurlDown], animations: {
                            self.studentLocationMapView.hidden = false;
                            }, completion: nil);
                        
                        UIView.transitionWithView(self.submitRecordButton, duration: 1.5, options: [.CurveEaseOut, UIViewAnimationOptions.TransitionCurlUp], animations: {
                            self.submitRecordButton.hidden = false;
                            }, completion: nil);
                        
                        let firstPlacemark = placemarks?.first
                        let placemark = MKPlacemark(placemark: firstPlacemark!)
                        var region = self.studentLocationMapView.region
                        region.center = (placemark.location?.coordinate)!
                        region.span.longitudeDelta /= 8.0
                        region.span.latitudeDelta /= 8.0
                        self.studentLocationMapView.setRegion(region, animated: true)
                        self.studentLocationMapView.addAnnotation(placemark)
                    }
                    else{
                        ParseClient.sharedInstance().showError(self, message: "Invalid Location. Try Entering Another Location", title: "Student Location", style: .Alert)
                    }
                }
            }
            else{
                ParseClient.sharedInstance().showError(self, message: "Something Went Wrong While Fetching Coordinates of Location. Try Entering More Specific Location", title: "Student Location", style: .Alert)
            }
        }
    }
    
    @IBAction func closeForm(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
