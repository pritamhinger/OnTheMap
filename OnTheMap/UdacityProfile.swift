//
//  UdacityProfile.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 20/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

struct UdacityProfile {
    let first_name : String
    let last_name : String
    
    init?(profileJSON:[String:AnyObject]){
        if profileJSON[ParseClient.UdacityProfileKeys.FirstName] != nil{
            if let firstName = profileJSON[ParseClient.UdacityProfileKeys.FirstName] as? String{
                first_name = firstName
            }
            else{
                first_name = ""
            }
        }
        else{
            first_name = ""
        }
        
        if profileJSON[ParseClient.UdacityProfileKeys.LastName] != nil{
            if let lastName = profileJSON[ParseClient.UdacityProfileKeys.LastName] as? String{
                last_name = lastName
            }
            else{
                last_name = ""
            }
        }
        else{
            last_name = ""
        }
    }
}