//
//  NewLocationViewController.swift
//  On the Map
//
//  Created by Siva Ganesh on 19/09/15.
//  Copyright (c) 2015 Siva Ganesh. All rights reserved.
//

import UIKit

import CoreLocation

class NewLocationViewController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        userLocation.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var userLocation: UITextView!
    
    
    @IBAction func findPlance(sender: AnyObject) {
        
        if(!userLocation.text.characters.isEmpty){
        let userUrlVC = self.storyboard?.instantiateViewControllerWithIdentifier("UserUrlViewController") as! UserUrlViewController
        
            userUrlVC.userAddress = userLocation.text
        
            self.presentViewController(userUrlVC, animated: true, completion: nil)
            
        }else{
            
            // userLocation.text = "Enter an Address"
            let alertController = UIAlertController(title: "Error", message:
                "Enter an Address", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        
        }
        
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText: String) -> Bool {
     
        if(replacementText == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
        
    }
    
}
