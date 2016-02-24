//
//  ComposeViewController.swift
//  TwitterLogIn
//
//  Created by Suyeon Kang on 2/23/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    override func viewDidLoad() {
    //    var profilePhoto: UIImageView = UIImageView()
        profilePhoto.setImageWithURL(NSURL(string: User.currentUser!.profileImageUrl!)!)
        profileButton.setBackgroundImage(profilePhoto.image, forState: .Normal)
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //TwitterClient(baseURL:)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
