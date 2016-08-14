//
//  Constants.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 14/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

extension ParseClient {
    
    struct ParseMethods {
        static let StudentLocation = "/StudentLocation";
    }
    
    struct  ParseAPI {
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr";
        static let RestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY";
        static let ApiScheme = "https";
        static let ApiHost = "parse.udacity.com";
        static let ApiPath = "/parse/classes";
    }
    
    struct  UdacityAPI {
        static let ApiScheme = "https";
        static let ApiHost = "www.udacity.com";
        static let ApiPath = "/api";
    }
    
    struct  UdacityMethods {
        static let UserProfile = "/users";
        static let Session = "/session";
    }
    
    struct ParseParameterKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
    }
    
    struct  StudentReponseKeys {
        static let Results = "results";
        static let CreatedAt = "createdAt";
        static let FirstName = "firstName";
        static let LastName = "lastName";
        static let Latitude = "latitude";
        static let Longitude = "longitude";
        static let MapString = "mapString";
        static let MediaURL = "mediaURL";
        static let ObjectId = "objectId";
        static let UniqueKey = "uniqueKey";
        static let UpdatedAt = "updatedAt";
        
    }
    
    struct HeaderKeys {
        static let ApplicationIdHeader = "X-Parse-Application-Id";
        static let RestKeyHeader = "X-Parse-REST-API-Key";
        static let Accept = "Accept";
        static let ContentType = "Content-Type";
    }
    
    struct HeaderValues {
        static let ApplicationJson = "application/json";
    }
    
    struct HTTPMethods {
        static let POST = "POST";
        static let GET = "GET";
        static let DELETE = "DELETE";
        static let PUT = "PUT";
    }
}