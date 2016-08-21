//
//  Credential.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 15/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

struct Credential {
    let username:String
    let password:String
    let token:String
    let authProvider : ParseClient.AuthenticationProvider
    
    init(username:String, password:String, token:String, authProvider:ParseClient.AuthenticationProvider){
        self.username = username
        self.password = password
        self.token = token
        self.authProvider = authProvider
    }
}