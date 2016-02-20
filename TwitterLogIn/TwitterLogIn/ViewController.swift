//
//  ViewController.swift
//  TwitterLogIn
//
//  Created by Suyeon Kang on 2/15/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class ViewController: UIViewController {

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion(){
            (user: User?, error: NSError?) in
            print("login")
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
                //perform segue
            }else{
                //handle login error
            }
        }
//        TwitterClient.sharedInstance.loginWithBlock(){
//            //go to next screen
//        }
 
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "loginSegue") {
            let navigationController = segue.destinationViewController as! UINavigationController
            navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //TwitterClient(baseURL:)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

