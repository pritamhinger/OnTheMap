//
//  Student.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 14/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

struct Student {
    // Mark: - Student Properties
    
    let objectId:String
    var uniqueKey:String
    var firstName:String
    var lastName:String
    var mapLocation:String
    var mediaURL:String
    var latitude:Double
    var longitude:Double
    var createdAt:NSDate
    var updatedAt:NSDate
    
    init(){
        objectId = ""
        uniqueKey = ""
        firstName = ""
        lastName = ""
        mapLocation = ""
        mediaURL = ""
        latitude = 0.0
        longitude = 0.0
        createdAt = NSDate()
        updatedAt = NSDate()
    }
    
    init?(studentJSON:[String:AnyObject]){
        
        if let uniqueKey = studentJSON[ParseClient.StudentReponseKeys.UniqueKey] as? String{
            self.uniqueKey = uniqueKey
        }
        else{
            return nil
        }
        
        self.objectId = studentJSON[ParseClient.StudentReponseKeys.ObjectId] as! String
        self.firstName = studentJSON[ParseClient.StudentReponseKeys.FirstName] as! String
        self.lastName = studentJSON[ParseClient.StudentReponseKeys.LastName] as! String
        self.mapLocation = studentJSON[ParseClient.StudentReponseKeys.MapString] as! String
        self.mediaURL = studentJSON[ParseClient.StudentReponseKeys.MediaURL] as! String
        self.latitude = studentJSON[ParseClient.StudentReponseKeys.Latitude] as! Double
        self.longitude = studentJSON[ParseClient.StudentReponseKeys.Longitude] as! Double

        if let createdAtString = studentJSON[ParseClient.StudentReponseKeys.CreatedAt] as? String{
            self.createdAt = Student.formatDate(createdAtString)
        }
        else{
            self.createdAt = NSDate()
        }
        if let updatedAtString = studentJSON[ParseClient.StudentReponseKeys.UpdatedAt] as? String{
            self.updatedAt = Student.formatDate(updatedAtString)
        }
        else{
            self.updatedAt = NSDate()
        }
        
        return
    }
    
    static func parseStudentJSON(jsonReponse: [[String:AnyObject]], updateAppData:Bool){
        var students = [Student]()
        
        for currentStudentJSON in jsonReponse {
            if let currentStudent = Student(studentJSON: currentStudentJSON){
                students.append(currentStudent)
            }
        }
        
        if updateAppData {
            AppData.sharedInstance.students = students
        }
        else{
            AppData.sharedInstance.currentStudent = students
        }
        
        return
    }
    
    static func formatDate(dateString:String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd\'T\'HH:mm:ss.SSSZ"
        let date = dateFormatter.dateFromString(dateString)
        return date!
    }
}