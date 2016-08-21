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
                    Student.parseStudentJSON(results, updateAppData: true)
                    completionHandlerForStudents(result: AppData.sharedInstance.students, error: nil);
                }
                else{
                    completionHandlerForStudents(result: nil, error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
                }
            }
            else{
                completionHandlerForStudents(result: nil, error: error)
            }
        }
    }
    
    func getAuthenticationData(credential:Credential, completionHandlerForLogin: (result:AuthData?, error:NSError?) -> Void) {
        
        var jsonBody = ""
        if credential.authProvider == AuthenticationProvider.Udacity{
            jsonBody = "{\"udacity\":{\"username\":\"\(credential.username)\", \"password\":\"\(credential.password)\"}}"
        }
        else if credential.authProvider == AuthenticationProvider.Facebook{
            jsonBody = "{\"facebook_mobile\": {\"access_token\": \"\(credential.token);\"}}"
        }
        
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
    
    func logoutFromUdacity(logoutCompletionHandler: (results:AnyObject?, error: NSError?) -> Void) {
        ParseClient.sharedInstance().taskForLogout(ParseClient.UdacityMethods.Session){ (results, error) in
            if error == nil{
                logoutCompletionHandler(results: results, error: nil)
            }
            else{
                logoutCompletionHandler(results: nil, error: error)
            }
        }
    }
    
    func getStudentPublicUdacityProfile(method:String, completionHandler: (results:UdacityProfile?, error:NSError?) -> Void){
        let resourcePath = "\(ParseClient.UdacityMethods.UserProfile)/\(method)"
        ParseClient.sharedInstance().taskForGetFromUdacity(resourcePath){ (results, error) in
            if error == nil{
                let profile = UdacityProfile(profileJSON: results[ParseClient.UdacityProfileKeys.User] as! [String : AnyObject])
                completionHandler(results: profile, error: nil)
            }
            else{
                completionHandler(results: nil, error: error)
            }
        }
    }
    
    func getStudentInformation(parameters:[String:String], completionHandler: (student:Student?, error:NSError?) -> Void) {
        ParseClient.sharedInstance().taskForGetMethod(ParseClient.ParseMethods.StudentLocation, parameters: parameters){ (results, error) in
            if error == nil{
                print(results)
                if let result = results[ParseClient.StudentReponseKeys.Results] as? [[String:AnyObject]]{
                    Student.parseStudentJSON(result, updateAppData: false)
                    let students = AppData.sharedInstance.currentStudent
                    if students!.count > 0{
                        completionHandler(student: students!.first, error: nil)
                    }
                    else{
                        completionHandler(student: nil, error: NSError(domain: "Student Information", code: 1, userInfo: [NSLocalizedDescriptionKey: "Student Not present"]))
                    }
                }
                else{
                    completionHandler(student: nil, error: NSError(domain: "Student Information", code: 2, userInfo: [NSLocalizedDescriptionKey: "Student Not present"]))
                }
            }
            else{
                completionHandler(student: nil, error: error)
            }
        }
    }
    
    func updateOrInsertStudentInformation(student:Student, apiMethod:String, httpMethod:String, parameters:[String:String], completionHandler: (result:AnyObject?, error: NSError?) -> Void){
        let jsonBody = convertStudentDataToJSON(student)
        ParseClient.sharedInstance().taskForPostOrPutMethod(apiMethod, httpMethod: httpMethod, parameters: parameters, jsonBody: jsonBody){ (results, error) in
            if error == nil{
                completionHandler(result: results, error: nil)
            }
            else{
                completionHandler(result: nil, error: error)
            }
        }
    }
    
    func checkUserRecord(controller:UIViewController, completionHandler: (student:Student?, update:Bool, error: NSError?) -> Void) {
        let authData = (UIApplication.sharedApplication().delegate as! AppDelegate).authData
        let uniqueKey = authData?.user_key
        
        let parameter = ["where":"{\"uniqueKey\":\"\(uniqueKey!)\"}",
                         "order":"-updatedAt"]
        
        ParseClient.sharedInstance().getStudentInformation(parameter){ (student, error) in
            if error == nil{
                performUIUpdatesOnMain{
                    ParseClient.sharedInstance().showWarningController(controller, warningMessage: "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location", title: "Student Information", style: .Alert){ (update) in
                        completionHandler(student: student, update: update, error: nil)
                    }
                }
            }
            else{
                performUIUpdatesOnMain{
                    completionHandler(student: nil, update: false, error: error)
                }
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
                if error?.domain == NSURLErrorDomain{
                    completionHandler(placemarks: nil, error: error)
                }
                else{
                    let customError = NSError(domain: "GeoCodeError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Something Went Wrong While Fetching Coordinates of Location. Try Entering More Specific Location"])
                    completionHandler(placemarks: nil, error: customError)
                }
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
        controller.presentViewController(alertViewController, animated: true, completion: nil)
    }
    
    func showWarningController(controller:UIViewController, warningMessage:String, title:String, style:UIAlertControllerStyle, completionHandler: (update:Bool) -> Void){
        let alertViewController = UIAlertController(title: title, message: warningMessage, preferredStyle: style)
        let okAction = UIAlertAction(title: "Overwrite", style: .Default){ (action) in
            completionHandler(update: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default){ (action) in
            completionHandler(update: false)
        }
        
        alertViewController.addAction(okAction)
        alertViewController.addAction((cancelAction))
        controller.presentViewController(alertViewController, animated: true, completion: nil);
    }
    
    func extractUserFriendlyErrorMessage(error:NSError) -> String {
        var message = ""
        message = error.localizedDescription
        
        if message.characters.count == 0{
            message = "Houston, we have a problem here and we don't know it's cause either"
        }
        
        return message
    }
    
    func convertStudentDataToJSON(student:Student) -> String {
        let jsonString = "{\"\(StudentReponseKeys.UniqueKey)\":\"\(student.uniqueKey)\",\"\(StudentReponseKeys.FirstName)\":\"\(student.firstName)\", \"\(StudentReponseKeys.LastName)\":\"\(student.lastName)\", \"\(StudentReponseKeys.Latitude)\":\(student.latitude), \"\(StudentReponseKeys.Longitude)\":\(student.longitude), \"\(StudentReponseKeys.MapString)\":\"\(student.mapLocation)\",\"\(StudentReponseKeys.MediaURL)\":\"\(student.mediaURL)\"}"
        return jsonString
    }
}