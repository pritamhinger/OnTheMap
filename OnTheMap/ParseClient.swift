//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 14/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    // MARK: - Properties
    let session = NSURLSession.sharedSession();
    
    // MARK: - Initializers
    override init() {
        super.init()
    }
    
    // MARK: - Networking Tasks
    func taskForGetMethod(method:String, parameters:[String:AnyObject], completionHandlerForGET:(result:AnyObject!, error:NSError?) -> Void) -> NSURLSessionDataTask {
        
        var parametersWithApiKey = parameters;
        let request = NSMutableURLRequest(URL: parseURLFromParameters(parametersWithApiKey, withPathExtension: method));
        request.addValue(ParseClient.ParseAPI.ApplicationID, forHTTPHeaderField: ParseClient.HeaderKeys.ApplicationIdHeader);
        request.addValue(ParseClient.ParseAPI.RestAPIKey, forHTTPHeaderField: ParseClient.HeaderKeys.RestKeyHeader);
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(errorString: String) {
                print(errorString)
                let userInfo = [NSLocalizedDescriptionKey : errorString]
                completionHandlerForGET(result: nil, error: NSError(domain: (error?.domain)!, code: (error?.code)!, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError((error?.localizedDescription)!);
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
        
    }
    
    func taskForPostOrPutMethod(method: String, httpMethod:String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        
        let request = NSMutableURLRequest(URL: parseURLFromParameters(parametersWithApiKey, withPathExtension: method))
        request.HTTPMethod = httpMethod
        request.addValue(ParseClient.ParseAPI.ApplicationID, forHTTPHeaderField: ParseClient.HeaderKeys.ApplicationIdHeader);
        request.addValue(ParseClient.ParseAPI.RestAPIKey, forHTTPHeaderField: ParseClient.HeaderKeys.RestKeyHeader);
        request.addValue(ParseClient.HeaderValues.ApplicationJson, forHTTPHeaderField: ParseClient.HeaderKeys.Accept)
        request.addValue(ParseClient.HeaderValues.ApplicationJson, forHTTPHeaderField: ParseClient.HeaderKeys.ContentType)
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(errorString: String) {
                print(errorString)
                let userInfo = [NSLocalizedDescriptionKey : errorString]
                completionHandlerForPOST(result: nil, error: NSError(domain: (error?.domain)!, code: (error?.code)!, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError((error?.localizedDescription)!);
                return
            }
            
            //print("\(NSString(data: data!, encoding: NSUTF8StringEncoding))");
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func taskForLogin(method:String, jsonBody:String, completionHandlerForLogin: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        print("Login JSON is \(jsonBody)")
        //let request = NSMutableURLRequest(URL: NSURL(string:"https://www.udacity.com/api/session")!);
        let request = NSMutableURLRequest(URL: udacityURLFromParameters(method));
        request.HTTPMethod = ParseClient.HTTPMethods.POST;
        request.addValue(ParseClient.HeaderValues.ApplicationJson, forHTTPHeaderField: ParseClient.HeaderKeys.Accept);
        request.addValue(ParseClient.HeaderValues.ApplicationJson, forHTTPHeaderField: ParseClient.HeaderKeys.ContentType);
        request.HTTPBody = jsonBody.dataUsingEncoding(NSUTF8StringEncoding);
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(errorString: String) {
                print(errorString);
                let userInfo = [NSLocalizedDescriptionKey : errorString];
                completionHandlerForLogin(result: nil, error: NSError(domain: (error?.domain)!, code: (error?.code)!, userInfo: userInfo));
            }
            
            guard (error == nil) else {
                sendError((error?.localizedDescription)!);
                return;
            }
            print("\(NSString(data: data!, encoding: NSUTF8StringEncoding))");
            if let statusCode = (response as? NSHTTPURLResponse)?.statusCode{
                print("status code is \(statusCode)")
                if(statusCode == 403){
                    let userInfo = [NSLocalizedDescriptionKey : "Username or password is invalid"];
                    completionHandlerForLogin(result: nil, error: NSError(domain: "Login Task", code: 1, userInfo: userInfo));
                    return
                }
                if(statusCode  >= 299){
                   sendError("Your request returned a status code other than 2xx!");
                    return
                }
                
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!");
                return;
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5));
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForLogin);
        }
        
        task.resume();
        
        return task;
        
    }
    
    func taskForGetFromUdacity(method:String, completionHandlerForLogin: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let request = NSMutableURLRequest(URL: udacityURLFromParameters(method));
        request.HTTPMethod = ParseClient.HTTPMethods.GET;
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(errorString: String) {
                print(errorString);
                let userInfo = [NSLocalizedDescriptionKey : errorString];
                completionHandlerForLogin(result: nil, error: NSError(domain: (error?.domain)!, code: (error?.code)!, userInfo: userInfo));
            }
            
            guard (error == nil) else {
                sendError((error?.localizedDescription)!)
                return;
            }
            
            if let statusCode = (response as? NSHTTPURLResponse)?.statusCode{
                print("status code is \(statusCode)")
                if(statusCode == 403){
                    let userInfo = [NSLocalizedDescriptionKey : "Username or password is invalid"];
                    completionHandlerForLogin(result: nil, error: NSError(domain: "Login Task", code: 1, userInfo: userInfo));
                    return
                }
                if(statusCode  >= 299){
                    sendError("Your request returned a status code other than 2xx!");
                    return
                }
                
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!");
                return;
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5));
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForLogin);
        }
        
        task.resume();
        
        return task;
        
    }
    
    func taskForLogout(method:String, logoutCompletionHandler: (result:AnyObject?, error : NSError?) -> Void) -> NSURLSessionDataTask{
        let request = NSMutableURLRequest(URL: udacityURLFromParameters(method));
        request.HTTPMethod = ParseClient.HTTPMethods.DELETE;
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func sendError(errorString: String) {
                print(errorString);
                let userInfo = [NSLocalizedDescriptionKey : errorString];
                logoutCompletionHandler(result: nil, error: NSError(domain: (error?.domain)!, code: (error?.code)!, userInfo: userInfo));
            }
            
            guard (error == nil) else {
                sendError((error?.localizedDescription)!)
                return;
            }
            
            if let statusCode = (response as? NSHTTPURLResponse)?.statusCode{
                print("status code is \(statusCode)")
                if(statusCode == 403){
                    let userInfo = [NSLocalizedDescriptionKey : "Username or password is invalid"];
                    logoutCompletionHandler(result: nil, error: NSError(domain: "Login Task", code: 1, userInfo: userInfo));
                    return
                }
                if(statusCode  >= 299){
                    sendError("Your request returned a status code other than 2xx!");
                    return
                }
                
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!");
                return;
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5));
            
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: logoutCompletionHandler);
        }
        
        task.resume();
        
        return task;
    }
    
    // MARK: - Helper Methods
    private func parseURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = ParseClient.ParseAPI.ApiScheme;
        components.host = ParseClient.ParseAPI.ApiHost
        components.path = ParseClient.ParseAPI.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    private func udacityURLFromParameters(withPathExtension: String? = nil) -> NSURL {
        let components = NSURLComponents()
        components.scheme = ParseClient.UdacityAPI.ApiScheme;
        components.host = ParseClient.UdacityAPI.ApiHost
        components.path = ParseClient.UdacityAPI.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        return components.URL!
    }
    
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let output = NSString(data: data, encoding: NSUTF8StringEncoding);
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(output)'"]
            completionHandlerForConvertData(result: nil, error: NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    // MARK: - Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
}