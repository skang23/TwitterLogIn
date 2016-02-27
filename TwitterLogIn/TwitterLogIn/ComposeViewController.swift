//
//  ComposeViewController.swift
//  TwitterLogIn
//
//  Created by Suyeon Kang on 2/23/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextFieldDelegate {
    @IBAction func popController(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var textField: UITextField!
    var screenname: String?
    @IBAction func statusUpdate(sender: AnyObject) {
        if screenname == nil {
        let params = ["status": textField.text!] as NSDictionary
        TwitterClient.sharedInstance.statusUpdateWithParams(params)
       }
        else{
            let params = ["text": textField.text!, "screen_name": screenname!] as NSDictionary
            TwitterClient.sharedInstance.replyWithParams(params)
        }
        popController(self.textField)
    }
    
    @IBOutlet weak var wordCount: UITextView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBAction func countText(sender: AnyObject) {
        
        let count = 140 - textField.text!.characters.count
        wordCount.text = "\(count)"
    }
    override func viewDidLoad() {
    //    var profilePhoto: UIImageView = UIImageView()
        profilePhoto.setImageWithURL(NSURL(string: User.currentUser!.profileImageUrl!)!)
        profileButton.setBackgroundImage(profilePhoto.image, forState: .Normal)
        if(screenname != nil){
        textField.placeholder = "@\(screenname!)"
        }
        textField.delegate = self
        super.viewDidLoad()
        // Do any additional setup aft er loading the view, typically from a nib.
        
        //TwitterClient(baseURL:)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
