//
//  ParseHelper.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 15/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension ParseClient{
    
    func getEnrolledStudents(completionHandlerForStudents: (result:[Student]?, error: NSError?) -> Void) {
        let parameters = prepareSortParameter()
        ParseClient.sharedInstance().taskForGetMethod(ParseClient.ParseMethods.StudentLocation, parameters: parameters){ (results, error) in
            if error == nil{
                if let results = results[ParseClient.StudentReponseKeys.Results] as? [[String:AnyObject]]{
                    let students = Student.parseStudentJSON(results);
                    completionHandlerForStudents(result: students, error: nil);
                }
                else{
                    completionHandlerForStudents(result: nil, error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]));
                }
            }
            else{
                completionHandlerForStudents(result: nil, error: error);
            }
        }
    }
    
    func getAuthenticationData(credential:Credential, completionHandlerForLogin: (result:AuthData?, error:NSError?) -> Void) {
        let jsonBody = "{\"udacity\":{\"username\":\"\(credential.username)\", \"password\":\"\(credential.password)\"}}";
        ParseClient.sharedInstance().taskForLogin(ParseClient.UdacityMethods.Session, jsonBody: jsonBody){ (result, error) in
            if error == nil{
                let authData = AuthData(jsonResponse: result as! [String : [String : AnyObject]])
                completionHandlerForLogin(result: authData, error: nil)
            }
            else{
                completionHandlerForLogin(result: nil, error: error)
            }
        }
    }
    
    func getStudentInformation(parameters:[String:String], completionHandler: (student:Student?, error:NSError?) -> Void) {
        ParseClient.sharedInstance().taskForGetMethod(ParseClient.ParseMethods.StudentLocation, parameters: parameters){ (results, error) in
            if error == nil{
                print(results)
                if let result = results[ParseClient.StudentReponseKeys.Results] as? [[String:AnyObject]]{
                    let students = Student.parseStudentJSON(result)
                    if students.count > 0{
                        completionHandler(student: students.first, error: nil);
                    }
                    else{
                        completionHandler(student: nil, error: NSError(domain: "Student Information", code: 0, userInfo: [NSLocalizedDescriptionKey: "Student Not present"]));
                    }
                }
                else{
                    completionHandler(student: nil, error: NSError(domain: "Student Information", code: 0, userInfo: [NSLocalizedDescriptionKey: "Student Not present"]));
                }
            }
            else{
                completionHandler(student: nil, error: error);
            }
        }

    }
    
    func getLatLongForAddress(location:String, completionHandler: (placemarks: [CLPlacemark]?, error: NSError?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location){ (placeMarks, error) in
            if error == nil{
                if placeMarks?.count > 0{
                    completionHandler(placemarks: placeMarks, error: nil)
                }
                else{
                    completionHandler(placemarks: [], error: nil)
                }
            }
            else{
                completionHandler(placemarks: nil, error: error)
            }
        }
    }
    
    func prepareSortParameter() -> [String: String]{
        let sortParameter = (UIApplication.sharedApplication().delegate as! AppDelegate).sortParameter
        let orderByParameter = "\(sortParameter.sortDirection == SortDirection.Descending ? "-" : "")\(sortParameter.sortByColumn)"
        let parameters = [ParseClient.ParseParameterKeys.Limit:"\(sortParameter.pageSize)",
                          ParseClient.ParseParameterKeys.Order:"\(orderByParameter)"]
        return parameters
    }
    
    func showError(controller:UIViewController, message:String, title:String, style:UIAlertControllerStyle){
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertViewController.addAction(okAction)
        controller.presentViewController(alertViewController, animated: true, completion: nil);
    }
    
    func showWarningController(controller:UIViewController, warningMessage:String, title:String, style:UIAlertControllerStyle, completionHandler: (update:Bool) -> Void){
        let alertViewController = UIAlertController(title: title, message: warningMessage, preferredStyle: style)
        let okAction = UIAlertAction(title: "Overwrite", style: .Default){ (action) in
            print("Okay pressed")
            completionHandler(update: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default){ (action) in
            print("Cancel Pressed")
            completionHandler(update: false)
            
        }
        alertViewController.addAction(okAction)
        alertViewController.addAction((cancelAction))
        controller.presentViewController(alertViewController, animated: true, completion: nil);
    }
}