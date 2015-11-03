//
//  UserUrlViewController.swift
//  On the Map
//
//  Created by Siva Ganesh on 21/09/15.
//  Copyright (c) 2015 Siva Ganesh. All rights reserved.
//

import UIKit

import MapKit
import CoreLocation


class UserUrlViewController: UIViewController {

    var userAddress = ""
    
    var userUrl = ""
    var lat = ""
    var long = ""
    
    @IBOutlet weak var activityIndicatorIcon: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startActivityIndicator()
        
        // Reverse address to Co-ordinate
        let address = userAddress
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if let placemark = placemarks?[0]{
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                
                self.lat = placemark.location!.coordinate.latitude.description
                self.long = placemark.location!.coordinate.longitude.description
                
                let initialLocation = CLLocation(latitude: placemark.location!.coordinate.latitude, longitude: placemark.location!.coordinate.longitude)
                self.centerMapOnLocation(initialLocation)
                self.stopActivityIndicator()
                
                print(self.lat)
            }else{

                self.stopActivityIndicator()
                
                let alertController = UIAlertController(title: "Error", message:
                    "Unable to find the given address. Please Enter a new Address", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                
                self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)

            }
        })

        // Do any additional setup after loading the view.
    }
    
    

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var userUrlField: UITextField!
    
    
    @IBAction func submitPressed(sender: AnyObject) {
        
        userUrl = userUrlField.text!
        
        if(!userUrl.characters.isEmpty && UserFunctions.isValidUrl(userUrl)){
            
            
            let accId = UserFunctions.user_id
            UserFunctions.getUserDetails(accId){ (success, errorMessage) in
                if success {
                    
                    let fullDetails = ["uniqueKey" : UserFunctions.user_id,"firstName" : UserFunctions.firstName, "lastName" : UserFunctions.lastName,"mapString" : self.userAddress,"mediaURL" : self.userUrl,"latitude" : (self.lat as NSString).doubleValue,"longitude" : (self.long as NSString).doubleValue]
                    
                    UserFunctions.updateUserLocationInParse(fullDetails){ (success, errorMessage) in
                        if success {
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.performSegueWithIdentifier("newLocationToTabBarSegue", sender: nil)
                                }
                            }
                            
                        }else{
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                                let alertController = UIAlertController(title: "Error", message:
                                    errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }
                            
                            
                        }
                    }
                    
                }else{
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            // let errorMsg = parsedResult["error"] as? String
                            let alertController = UIAlertController(title: "Error", message:
                                errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    }
                    
                }
            }
                    
            
        }else{
        
            let alertController = UIAlertController(title: "Error", message:
                "Enter a valid URL. Include http or https", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        
        }
        
    }
    
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func browseBtnPressed(sender: AnyObject) {
        
        userUrl = userUrlField.text!
        if(!userUrl.characters.isEmpty && UserFunctions.isValidUrl(userUrl)){
            
            let givenURL = userUrl
            let webVC = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
            webVC.urlString =  givenURL
            self.presentViewController(webVC, animated: true, completion: nil)
            
        }else{
        
            let alertController = UIAlertController(title: "Error", message:
                "Unable to find the given address. Please Enter a new Address", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func startActivityIndicator(){
        
        activityIndicatorIcon.startAnimating()
        activityIndicatorIcon.hidden = false
    
    }
    
    func stopActivityIndicator(){
        
        activityIndicatorIcon.stopAnimating()
        activityIndicatorIcon.hidden = true
        
    }
    
    
    @IBAction func resignKeyboard(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    

}
