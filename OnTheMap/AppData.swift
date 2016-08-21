//
//  AppData.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 21/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

class AppData {
    var students:[Student]?
    var currentStudent:[Student]?
    
    private init(){
        
    }
    
    // MARK: - Shared Instance
    class var sharedInstance: AppData{
        struct Singleton {
            static let instance = AppData()
        }
        
        return Singleton.instance
    }
}