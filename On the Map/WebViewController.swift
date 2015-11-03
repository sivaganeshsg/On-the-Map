//
//  WebViewController.swift
//  On the Map
//
//  Created by Siva Ganesh on 10/09/15.
//  Copyright (c) 2015 Siva Ganesh. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var urlString = "www.google.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        requestURL.loadRequest(request)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var requestURL: UIWebView!

    @IBAction func backBtn(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
