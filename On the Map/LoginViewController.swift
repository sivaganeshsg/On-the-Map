//
//  ViewController.swift
//  On the Map
//
//  Created by Siva Ganesh on 10/09/15.
//  Copyright (c) 2015 Siva Ganesh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    
    @IBAction func loginPressed(sender: AnyObject) {
        
        if(usernameField.text!.characters.isEmpty){
            
            loginMsgLabel.text = "Username Field is required"
            loginMsgLabel.hidden = false
        
        }else if(passwordField.text!.characters.isEmpty){
            loginMsgLabel.text = "Password Field is required"
            loginMsgLabel.hidden = false
            
        }else{
            loginMsgLabel.hidden = true
            loginProcess()
            
        }
        
        
    }
    
    
    @IBOutlet weak var loginMsgLabel: UILabel!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func signUp(sender: AnyObject) {
        
        let udacityRegisterURL = "https://www.udacity.com/account/auth#!/signup"
        let webVC = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        webVC.urlString =  udacityRegisterURL
        self.presentViewController(webVC, animated: true, completion: nil)
        
    }
        
    var session = NSURLSession.sharedSession()
    
    
    func loginProcess(){
    
        let uname = usernameField.text
        let pass = passwordField.text
        
        self.beforeLoginComplete()
        
        
        UserFunctions.loginUser(uname!, password: pass!){ (success, errorMessage) in

            if success {

                dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("loggedInSegue", sender: self)
                });
                
                self.afterLoginComplete()
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), {
                    let alertController = UIAlertController(title: "Error", message:
                        errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    self.shakeLoginBtn()
                    self.afterLoginComplete()
                    
                });
            }
        }
        
      

    }
    
    func shakeLoginBtn(){
        
        let bounds = self.loginButton.bounds
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
            self.loginButton.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width , height: bounds.size.height)
            }, completion: nil)
    
    }
    
    func beforeLoginComplete(){
    
        loginButton.enabled = false
        loginMsgLabel.text = "Verifying.. Please wait"
        loginMsgLabel.hidden = false
        
    }
    
    func afterLoginComplete(){
        
        loginButton.enabled = true
        loginMsgLabel.text = ""
        loginMsgLabel.hidden = true

    }
    
    @IBAction func resignKeyboard(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    

}

