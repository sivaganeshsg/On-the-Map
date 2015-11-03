//
//  UserLocations.swift
//  On the Map
//
//  Created by Siva Ganesh on 19/09/15.
//  Copyright (c) 2015 Siva Ganesh. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class UserLocations {

    // For Test drive 
    static func hardCodedLocationData() -> [[String : AnyObject]] {
        return  [
            [
                "createdAt" : "2015-02-24T22:27:14.456Z",
                "firstName" : "Jessica",
                "lastName" : "Uelmen",
                "latitude" : 28.1461248,
                "longitude" : -82.75676799999999,
                "mapString" : "Tarpon Springs, FL",
                "mediaURL" : "www.linkedin.com/in/jessicauelmen/en",
                "objectId" : "kj18GEaWD8",
                "uniqueKey" : 872458750,
                "updatedAt" : "2015-03-09T22:07:09.593Z"
            ], [
                "createdAt" : "2015-02-24T22:35:30.639Z",
                "firstName" : "Gabrielle",
                "lastName" : "Miller-Messner",
                "latitude" : 35.1740471,
                "longitude" : -79.3922539,
                "mapString" : "Southern Pines, NC",
                "mediaURL" : "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en",
                "objectId" : "8ZEuHF5uX8",
                "uniqueKey" : 2256298598,
                "updatedAt" : "2015-03-11T03:23:49.582Z"
            ], [
                "createdAt" : "2015-02-24T22:30:54.442Z",
                "firstName" : "Jason",
                "lastName" : "Schatz",
                "latitude" : 37.7617,
                "longitude" : -122.4216,
                "mapString" : "18th and Valencia, San Francisco, CA",
                "mediaURL" : "http://en.wikipedia.org/wiki/Swift_%28programming_language%29",
                "objectId" : "hiz0vOTmrL",
                "uniqueKey" : 2362758535,
                "updatedAt" : "2015-03-10T17:20:31.828Z"
            ], [
                "createdAt" : "2015-03-11T02:48:18.321Z",
                "firstName" : "Jarrod",
                "lastName" : "Parkes",
                "latitude" : 34.73037,
                "longitude" : -86.58611000000001,
                "mapString" : "Huntsville, Alabama",
                "mediaURL" : "https://linkedin.com/in/jarrodparkes",
                "objectId" : "CDHfAy8sdp",
                "uniqueKey" : 996618664,
                "updatedAt" : "2015-03-13T03:37:58.389Z"
            ]
        ]
    }
    
    
    static func getLocation(success: ((success: Bool, parseData: NSData!) -> Void)) {
        
        
        let request = NSMutableURLRequest(URL: NSURL(string:
            "https://api.parse.com/1/classes/StudentLocation?limit=100&order=-updatedAt")!)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        loadDataFromParse(request, completion:{(data, error) -> Void in
            if let urlData = data {
                success(success: true,parseData: urlData)
            }else{
                success(success: false, parseData: nil)
            }
        })
    }
    
    static func loadDataFromParse(request: NSMutableURLRequest, completion:(data: NSData?, error: NSError?) -> Void) {
        
        let session = NSURLSession.sharedSession()
        
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain:"DomainName", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }
    
    static var studentInformationArr: [StudentInformation] = []
    
    static func parseStudentLocationData(jsonResponse: NSDictionary) -> Void {

        let userData = jsonResponse["results"] as! NSArray
        // To remove old data
        studentInformationArr.removeAll()
        for dictionary in userData {
            if let student = UserFunctions.studentInfoFromDictionary(dictionary as! NSDictionary) {
                studentInformationArr.append(student)
            }
        }
        
    }
    
    
}
