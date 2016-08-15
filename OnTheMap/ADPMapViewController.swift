//
//  ADPMapViewController.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 15/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit
import MapKit

class ADPMapViewController: UIViewController,MKMapViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!

    //private var students: [Student]?;
    // MARK: - Controller View Cycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self;
        mapView.showsUserLocation = false
        mapView.zoomEnabled = true
        
        ParseClient.sharedInstance().getEnrolledStudents(){(result, error) in
            if error == nil{
                performUIUpdatesOnMain{
                    if let result = result{
                        self.addStudentToMap(result)
                        (UIApplication.sharedApplication().delegate as! AppDelegate).students = result;
                    }
                }
            }
            else{
                
            }
        }
    }
    

    // MARK: - Map View Delegate Methods
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        let reusePin = "studentLocation"
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reusePin) as? MKPinAnnotationView
        if pin == nil{
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusePin)
            pin?.canShowCallout = true
            pin?.animatesDrop = true
            pin?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure);
        }
        else{
            pin?.annotation = annotation
        }
        
        return pin
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let currentStudentAnnotation = view.annotation as! MKPointAnnotation;
        print(currentStudentAnnotation.title!)
        print(currentStudentAnnotation.subtitle!)
        if let url = NSURL(string: currentStudentAnnotation.subtitle!){
            UIApplication.sharedApplication().openURL(url);
        }
        else{
            
        }
    }
    
    
    // MARK: - Navigation

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if(segue.identifier == "mapIdentifier"){
//            if let currentStudentAnnotation  = (sender as! MKAnnotationView).annotation as! MKPointAnnotation!{
//                print(currentStudentAnnotation.title)
//                print(currentStudentAnnotation.subtitle)
//            }
//        }
//    }
 
    
    // MARK: - Private Methods
    func addStudentToMap(students:[Student]) -> Void {
        for student in students {
            let studentCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2DMake(student.latitude, student.longitude)
            let annotation = MKPointAnnotation()
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL
            
            annotation.coordinate = studentCoordinates
            mapView.addAnnotation(annotation);
            
        }
    }

}
