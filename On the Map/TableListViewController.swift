//
//  TableListViewController.swift
//  On the Map
//
//  Created by Siva Ganesh on 10/09/15.
//  Copyright (c) 2015 Siva Ganesh. All rights reserved.
//

import UIKit

class TableListViewController: UIViewController {

    var locations = [[String: AnyObject]]()
    
    
    @IBOutlet weak var userList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.userList?.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserLocations.studentInformationArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "UserCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! TableListViewCell
        cell.listImage.image = UIImage(named: "pin")
        let first = UserLocations.studentInformationArr[indexPath.row].firstName
        let last = UserLocations.studentInformationArr[indexPath.row].lastName
        cell.userName.text = "\(first) \(last)"
        cell.userLink.text = UserLocations.studentInformationArr[indexPath.row].mediaURL
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let mediaUrl = UserLocations.studentInformationArr[indexPath.row].mediaURL
        let goToMediaUrl = NSURL(string: mediaUrl)
        UIApplication.sharedApplication().openURL(goToMediaUrl!)
            
        
    }
    
    func getUserLocation(){
        
        print("fetching locations in table view")
        UserLocations.getLocation { (success, parseData) -> Void in
            if(success){
            
                let jsonResponse = (try! NSJSONSerialization.JSONObjectWithData(parseData!, options: NSJSONReadingOptions.AllowFragments)) as? NSDictionary
                
                if let jsonResponse = jsonResponse {
                    UserLocations.parseStudentLocationData(jsonResponse)
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        self.userList.reloadData()
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
        
    }

    @IBAction func logoutBtnPressed(sender: AnyObject) {
        
        UserFunctions.logoutUser()
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(loginVC, animated: true, completion: nil)
        
    }

}
