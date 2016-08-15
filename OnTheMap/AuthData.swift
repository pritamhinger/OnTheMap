//
//  AuthData.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 15/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

struct AuthData {
    let registered:Bool
    let user_key: String
    let sessionId:String
    let expiration:NSDate
    
    init?(jsonResponse:[String:[String:AnyObject]]){
        if let account = jsonResponse[ParseClient.LoginResponseKeys.Account]{
            self.registered = account[ParseClient.LoginResponseKeys.Registered] as! Bool
            self.user_key = account[ParseClient.LoginResponseKeys.Key] as! String
        }
        else{
            return nil;
        }
        
        if let session = jsonResponse[ParseClient.LoginResponseKeys.Session]{
            self.sessionId = session[ParseClient.LoginResponseKeys.Id] as! String
            self.expiration =  dateFromString(session[ParseClient.LoginResponseKeys.Expiration] as! String)
        }
        else{
            return nil
        }
    }
}