//
//  ADPNewRecordViewController.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 19/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit
import MapKit

class ADPNewRecordViewController: UIViewController, UITextFieldDelegate {

    var student:Student? = nil
    var chosenLocation = ""
    var clLocationCoordinate2D:CLLocationCoordinate2D?
    
    @IBOutlet weak var studentLocationMapView: MKMapView!
    @IBOutlet weak var locationTextBox: UITextField!
    @IBOutlet weak var submitRecordButton: UIButton!
    @IBOutlet weak var inputDescriptionLabel: UILabel!
    @IBOutlet weak var findOnMapLabel: UIButton!
    
    // MARK: - COntroller Life Cycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextBox.delegate = self
        if student != nil{
            prepareUI()
        }
        
        let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(ADPNewRecordViewController.tap(_:)))
        view.addGestureRecognizer(tapGestureReconizer);
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
                        
                        self.chosenLocation = self.locationTextBox.text!
                        if self.student == nil{
                            self.locationTextBox.text = "";
                        }
                        else{
                            self.locationTextBox.text = self.student?.mediaURL
                        }
                        
                        self.locationTextBox.placeholder = ParseClient.Label.MediaURLInputPlaceholder
                        self.findOnMapLabel.hidden = true
                        self.inputDescriptionLabel.text = ParseClient.Label.MediaURLInputText
                        
                        let firstPlacemark = placemarks?.first
                        let placemark = MKPlacemark(placemark: firstPlacemark!)
                        var region = self.studentLocationMapView.region
                        region.center = (placemark.location?.coordinate)!
                        region.span.longitudeDelta /= 8.0
                        region.span.latitudeDelta /= 8.0
                        self.studentLocationMapView.setRegion(region, animated: true)
                        self.studentLocationMapView.addAnnotation(placemark)
                        
                        self.clLocationCoordinate2D = placemark.location?.coordinate
                    }
                    else{
                        ParseClient.sharedInstance().showError(self, message: "Invalid Location. Try Entering Another Location", title: "Student Location", style: .Alert)
                    }
                }
            }
            else{
                performUIUpdatesOnMain{
                    let errorMessage = ParseClient.sharedInstance().extractUserFriendlyErrorMessage(error!)
                    ParseClient.sharedInstance().showError(self, message: errorMessage, title: "On The Map", style: .Alert);
                }
            }
        }
    }
    
    @IBAction func submitRecord(sender: UIButton) {
        if locationTextBox.text?.characters.count == 0{
                ParseClient.sharedInstance().showError(self, message: ParseClient.Label.MediaURLInputText, title: "", style: .Alert)
            return
        }
        
        var httpMethod = "";
        var apiMethod = ParseClient.ParseMethods.StudentLocation
        if student != nil{
            httpMethod = ParseClient.HTTPMethods.PUT
            student?.updatedAt = NSDate()
            apiMethod = "\(apiMethod)/\((student?.objectId)!)"
            if let userProfile = (UIApplication.sharedApplication().delegate as! AppDelegate).userProfile{
                student?.firstName = userProfile.first_name
                student?.lastName = userProfile.last_name
            }
            else{
                student?.firstName = ParseClient.Strings.FirstName
                student?.lastName = ParseClient.Strings.LastName
            }
        }
        else{
            httpMethod = ParseClient.HTTPMethods.POST
            student = Student()
            student?.uniqueKey = ((UIApplication.sharedApplication().delegate as! AppDelegate).authData?.user_key)!
            if let userProfile = (UIApplication.sharedApplication().delegate as! AppDelegate).userProfile{
                student?.firstName = userProfile.first_name
                student?.lastName = userProfile.last_name
            }
            else{
                student?.firstName = ParseClient.Strings.FirstName
                student?.lastName = ParseClient.Strings.LastName
            }
        }
        
        student?.mapLocation = chosenLocation
        student?.mediaURL = locationTextBox.text!
        
        student?.latitude = (clLocationCoordinate2D?.latitude)!
        student?.longitude = (clLocationCoordinate2D?.longitude)!
        
        ParseClient.sharedInstance().updateOrInsertStudentInformation(student!, apiMethod: apiMethod, httpMethod: httpMethod, parameters: [:]){ (results, error) in
            
            if error == nil{
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else{
                performUIUpdatesOnMain{
                    let errorMessage = ParseClient.sharedInstance().extractUserFriendlyErrorMessage(error!)
                    ParseClient.sharedInstance().showError(self, message: errorMessage, title: "On The Map", style: .Alert)
                }
            }
            
        }
    }
    
    @IBAction func closeForm(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - UITextField Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Gesture Event
    func tap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Private Methods
    func prepareUI() {
        inputDescriptionLabel.text = ParseClient.Label.LocationInputText
        locationTextBox.placeholder = ParseClient.Label.LocationInputPlaceholder
        if let location = student?.mapLocation{
            locationTextBox.text = location
        }
        
        if let latitude = student?.latitude,  let longitude = student?.longitude{
            let studentCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let annotation = MKPointAnnotation()
            var region = self.studentLocationMapView.region
            region.center = studentCoordinates
            region.span.latitudeDelta /= 8.0
            region.span.longitudeDelta /= 8.0
            annotation.coordinate = studentCoordinates
            self.studentLocationMapView.setRegion(region, animated: true)
            studentLocationMapView.addAnnotation(annotation)
            studentLocationMapView.hidden = false
            submitRecordButton.hidden = false
        }
    }
}
