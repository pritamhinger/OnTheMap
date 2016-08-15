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
                if let result = result{
                    self.addStudentToMap(result)
                    (UIApplication.sharedApplication().delegate as! AppDelegate).students = result
                }
            }
            else{
                
            }
        }
    }
    

    // MARK: - Map View Delegate Methods
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Private Methods
    func addStudentToMap(students:[Student]) -> Void {
        for student in students {
            let studentCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2DMake(student.latitude, student.longitude)
            let annotation = MKPointAnnotation()
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.coordinate = studentCoordinates
            mapView.addAnnotation(annotation);
        }
    }

}
