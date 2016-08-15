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
    
    init(username:String, password:String){
        self.username = username;
        self.password = password;
    }
}