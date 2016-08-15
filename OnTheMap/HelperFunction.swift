//
//  HelperFunction.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 15/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

func dateFromString(dateString:String) -> NSDate {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss.SSSZ"
    return dateFormatter.dateFromString(dateString)!
}

func stringFromDate(date:NSDate) -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss.SSSZ"
    return dateFormatter.stringFromDate(date)
}