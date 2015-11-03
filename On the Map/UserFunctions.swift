//
//  UserFunctions.swift
//  On the Map
//
//  Created by Siva Ganesh on 01/11/15.
//  Copyright © 2015 Siva Ganesh. All rights reserved.
//

import Foundation

class UserFunctions : NSObject{

    static var session = NSURLSession.sharedSession()
    
    static var user_id = ""
    static var session_id = ""
    static var firstName = ""
    static var lastName = ""
    
    
    
    static func loginUser(username : String, password: String, didComplete: (success: Bool, errorMessage: String?) -> Void){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let details = ["username" : username,"password" : password]
        let jsonBody = ["udacity" : details]
        
        var jsonifyError: NSError? = nil
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: [])
        } catch let error as NSError {
            jsonifyError = error
            request.HTTPBody = nil
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            
            if let error = downloadError {
                print("Could not complete the request \(error)")
                didComplete(success: false, errorMessage: "The Internet connection appears to be offline.")
                return
                
            } else {
                
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                let success = UserFunctions.parseUserData(newData)
                var errorMessage = ""
                if(!success){
                    errorMessage = "Invalid account details"
                }
                didComplete(success: success, errorMessage: errorMessage)
            }
        }
        
        task.resume()

        
    
    }
    
    static func parseUserData(data: NSData) -> Bool {
        var success = true;
        if  let userData = (try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)) as? NSDictionary,
        let account = userData["account"] as? [String: AnyObject],
        let session = userData["session"] as? [String: String]
        {
            user_id = account["key"] as! String
            session_id = session["id"]!
        } else {
            success = false
        }
        return success;
    }
    
    static func logoutUser(){
    
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! as [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
        }
        task.resume()
        
    
    }
    
    
    static func getUserDetails(userId: String, didComplete: (success: Bool, errorMessage: String?) -> Void){
        
        let urlString = "https://www.udacity.com/api/users/" + userId
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if let error = error {
                print("Could not complete the request \(error)")
                didComplete(success: false, errorMessage: "The Internet connection appears to be offline.")
                return
            }
            
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            var parsingError: NSError? = nil
            let parsedResult = (try! NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
            if let _ = parsedResult["status"] as? Int {
                
                let errorMsg = parsedResult["error"] as? String
                didComplete(success: false, errorMessage: errorMsg)
                return
                
            } else {
                if let userDet = parsedResult["user"] as? NSDictionary{
                    firstName = userDet["first_name"] as! String
                    lastName = userDet["last_name"] as! String
                    
                    didComplete(success: true, errorMessage: "")
                    
                }
            }
        }
        task.resume()
        
        
    }
    
    static func updateUserLocationInParse(userDet: NSDictionary, didComplete: (success: Bool, errorMessage: String?) -> Void){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print("updateUserLocationInParse")
        print(userDet)
        
        let mapString = userDet["mapString"]
        let mediaURL = userDet["mediaURL"]
        let lat = userDet["latitude"]
        let long = userDet["longitude"]
        
        let userParams = "{\"uniqueKey\": \"\(user_id)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString!)\", \"mediaURL\": \"\(mediaURL!)\",\"latitude\": \(lat!), \"longitude\": \(long!)}"
        
        print(userParams)
        request.HTTPBody = userParams.dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            if error != nil {
                didComplete(success: false, errorMessage: "Unable to Post data")
            }
            
            didComplete(success: true, errorMessage: "")

        }
        task.resume()
       
    }
    

    static func isValidUrl(urlString: String) -> Bool {
        let urlRequest = NSURLRequest(URL: NSURL(string: urlString)!)
        return NSURLConnection.canHandleRequest(urlRequest)
    }
    
    
    static func studentInfoFromDictionary(studentDictionary: NSDictionary) -> StudentInformation? {

        let studentFirstName = studentDictionary["firstName"] as! String
        let studentLastName = studentDictionary["lastName"] as! String
        let studentLongitude = studentDictionary["longitude"] as! Float
        let studentLatitude = studentDictionary["latitude"] as! Float
        let studentMediaURL = studentDictionary["mediaURL"] as! String
        let studentMapString = studentDictionary["mapString"] as! String
        let studentObjectID = studentDictionary["objectId"] as! String
        let studentUniqueKey = studentDictionary["uniqueKey"] as! String
        
        let finalStudentDictionary = ["firstName": studentFirstName, "lastName": studentLastName, "longitude": studentLongitude, "latitude": studentLatitude, "mediaURL": studentMediaURL, "mapString": studentMapString, "objectID": studentObjectID, "uniqueKey": studentUniqueKey]
        
        return StudentInformation(stuDict: finalStudentDictionary as! [String:AnyObject])
    }
    
    
}