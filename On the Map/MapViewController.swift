//
//  MapViewController.swift
//  On the Map
//
//  Created by Siva Ganesh on 10/09/15.
//  Copyright (c) 2015 Siva Ganesh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate  {

    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2000.0, regionRadius * 2000.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserLocation()
       

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            
            let mediaUrl = annotationView.annotation!.subtitle!!
            let goToMediaUrl = NSURL(string: mediaUrl)
            UIApplication.sharedApplication().openURL(goToMediaUrl!)
            
        }
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    func getUserLocation(){
    

        // No or less User Annotations in India region. So changed the initial location to US
        let initialLocation = CLLocation(latitude: 28.1461248, longitude: -82.75676799999999)
        centerMapOnLocation(initialLocation)

        print("fetching locations")
        UserLocations.getLocation { (success, parseData) -> Void in
            
            if(success){
            
            let jsonResponse = (try! NSJSONSerialization.JSONObjectWithData(parseData!, options: NSJSONReadingOptions.AllowFragments)) as? NSDictionary
                
            if let jsonResponse = jsonResponse {
                UserLocations.parseStudentLocationData(jsonResponse)
                
                for student in UserLocations.studentInformationArr{
                
                    let lat = CLLocationDegrees(student.latitude)
                    let long = CLLocationDegrees(student.longitude)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = student.firstName
                    let last = student.lastName
                    let mediaURL = student.mediaURL
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    self.annotations.append(annotation)
                    
                }
                
                self.mapView.addAnnotations(self.annotations)
                
                dispatch_async(dispatch_get_main_queue(),{
                        self.centerMapOnLocation(initialLocation)
                })
                    
            }
                
            }else{
            
                let alertController = UIAlertController(title: "Error", message:
                    "Unable to Fetch Users Location", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)

            }
                
        }
    
    }
    
    @IBAction func reloadBtnPressed(sender: AnyObject) {
        
        getUserLocation()
        mapView.reloadInputViews()
        
    }
    
    
    @IBAction func logoutPressed(sender: AnyObject) {
        
        UserFunctions.logoutUser()
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(loginVC, animated: true, completion: nil)
                
    }
    
    
    
    

}
