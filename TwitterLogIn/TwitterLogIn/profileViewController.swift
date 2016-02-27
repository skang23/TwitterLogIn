//
//  profileViewController.swift
//  TwitterLogIn
//
//  Created by Suyeon Kang on 2/25/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

import UIKit

class profileViewController: UIViewController {
    var user: User!
    
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var numTweets: UILabel!
    @IBOutlet weak var numFollowing: UILabel!
    
    @IBOutlet weak var numFollower: UILabel!

    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var screenname: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = user.name
        screenname.text = "@\(user.screenname!)"
        let dict = user.dictionary
        profilePhoto.setImageWithURL(NSURL(string: user.profileImageUrl!)!)
        let cover = dict["profile_background_image_url"] as! String
        coverPhoto.setImageWithURL(NSURL(string: cover)!)
        let followers = dict["followers_count"] as! Int
        let followings = dict["friends_count"] as! Int
        let tweetsCount = dict["statuses_count"] as! Int
        numFollower.text = "\(followers)"
        numFollowing.text = "\(followings)"
        numTweets.text = "\(tweetsCount)"
    
    }
    
    
}
