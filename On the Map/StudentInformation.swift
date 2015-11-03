//
//  StudentInformation.swift
//  On the Map
//
//  Created by Siva Ganesh on 01/11/15.
//  Copyright © 2015 Siva Ganesh. All rights reserved.
//

import Foundation


struct StudentInformation{

    let firstName: String
    let lastName: String
    let longitude: Float
    let latitude: Float
    let mediaURL: String
    let mapString: String
    let objectID: String
    let uniqueKey: String
    
    init(stuDict: [String: AnyObject]) {
        self.firstName = stuDict["firstName"] as! String
        self.lastName = stuDict["lastName"] as! String
        self.longitude = stuDict["longitude"] as! Float
        self.latitude = stuDict["latitude"] as! Float
        self.mediaURL = stuDict["mediaURL"] as! String
        self.mapString = stuDict["mapString"] as! String
        self.objectID = stuDict["objectID"] as! String
        self.uniqueKey = stuDict["uniqueKey"] as! String
    }

}