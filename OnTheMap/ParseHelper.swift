//
//  ParseHelper.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 15/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient{
    
    func getEnrolledStudents(completionHandlerForStudents: (result:[Student]?, error: NSError?) -> Void) {
        let parameters = prepareParameter()
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
    
    func prepareParameter() -> [String: String]{
        let sortParameter = (UIApplication.sharedApplication().delegate as! AppDelegate).sortParameter
        let orderByParameter = "\(sortParameter.sortDirection == SortDirection.Descending ? "-" : "")\(sortParameter.sortByColumn)"
        print("Order By Parameter Value is : \(orderByParameter)");
        let parameters = [ParseClient.ParseParameterKeys.Limit:"\(sortParameter.pageSize)",
                          ParseClient.ParseParameterKeys.Order:"\(orderByParameter)"]
        return parameters
    }
}