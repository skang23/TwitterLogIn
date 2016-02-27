//
//  DetailViewController.swift
//  TwitterLogIn
//
//  Created by Suyeon Kang on 2/25/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    var photo: UIImageView!
    var tweet: Tweet! {
        didSet{
            
         
        }
    }
    
    @IBAction func replyClicked(sender: AnyObject) {
    }
    @IBAction func retweetClicked(sender: AnyObject) {
        let params = ["id": tweet.tweetID!] as NSDictionary
        if self.tweet.retweeted > 0 {
            
            TwitterClient.sharedInstance.unretweetWithId(tweet, params: params, completion: {
                ()->() in  self.retweetCount.text = "\(self.tweet.retweetCount!)"
                
                let image = UIImage(named: "retweet")!
                self.retweetButton.setImage(image, forState: UIControlState.Normal)
                
                
            })
        }
        else {
            
            print(tweet.tweetID)
            TwitterClient.sharedInstance.retweetWithId(tweet, params: params, completion: {
                ()->() in  self.retweetCount.text = "\(self.tweet.retweetCount!)"
                if self.tweet.retweeted != 0 {
                    let image = UIImage(named: "retweeted")!
                    self.retweetButton.setImage(image, forState: UIControlState.Normal)
                }
                
            })
            
            
        }
        
     
        
    }
    
    
    @IBAction func likeClicked(sender: AnyObject) {
        let params = ["id": tweet.tweetID!] as NSDictionary
        if self.tweet.favorited > 0 {
            TwitterClient.sharedInstance.unfavoriteTweet(tweet, params: params, completion:{()->() in
                let image = UIImage(named: "like")!
                self.favoriteButton.setImage(image, forState: UIControlState.Normal)
                self.likeCount.text = "\(self.tweet.favoriteCount!)"
                
                
                
            })
            
            
            
            let image = UIImage(named: "liked")!
            favoriteButton.setImage(image, forState: UIControlState.Normal)
        }
        else {
            
            TwitterClient.sharedInstance.favoriteTweet(tweet, params: params, completion:{()->() in  if self.tweet.favorited != 0 {
                let image = UIImage(named: "liked")!
                self.favoriteButton.setImage(image, forState: UIControlState.Normal)
                self.likeCount.text = "\(self.tweet.favoriteCount!)"
                }
                
                
            })
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewdidload")
        view1.layer.borderWidth = 1
        view1.layer.borderColor = UIColor.blackColor().CGColor
        view2.layer.borderWidth = 1
        view2.layer.borderColor = UIColor.blackColor().CGColor
        profilePhoto.setImageWithURL(NSURL(string: tweet.profilePhoto!)!)
        
        userName.text = tweet.user?.name
        userID.text = "@\(tweet.user!.screenname!)"
        tweetLabel.text = tweet.text
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE\\MMM\\d"
        let current = NSDate()
        if current.daysFrom(tweet!.createdAt!) > 1{
            timeLabel.text = formatter.stringFromDate(tweet!.createdAt!)
        }
        else if current.hoursFrom(tweet!.createdAt!)>=1 {
            let timeFrom = current.hoursFrom(tweet!.createdAt!)
            timeLabel.text = "\(timeFrom) hours"
            
        }
        else if current.minutesFrom(tweet!.createdAt!)>=1{
            let timeFrom = current.minutesFrom(tweet!.createdAt!)
            timeLabel.text = "\(timeFrom) minutes"
        }
        else {
            let timeFrom = current.secondsFrom(tweet!.createdAt!)
            timeLabel.text = "\(timeFrom) seconds"
        }
        if tweet.retweeted > 0 {
            let image = UIImage(named: "retweeted")!
            retweetButton.setImage(image, forState: UIControlState.Normal)
        }
        else {
            let image = UIImage(named: "retweet")!
            retweetButton.setImage(image, forState: UIControlState.Normal)
            retweetButton.imageView?.clipsToBounds = true
            retweetButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            let image1 = UIImage(named: "retweet_pressed")!
            retweetButton.setImage(image1, forState: UIControlState.Highlighted)
            retweetButton.imageView?.clipsToBounds = true
            retweetButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            
        }
        if tweet.favorited > 0 {
            let image = UIImage(named: "liked")!
            favoriteButton.setImage(image, forState: UIControlState.Normal)
        }
        else {
            let image = UIImage(named: "like")!
            favoriteButton.setImage(image, forState: UIControlState.Normal)
            let image1 = UIImage(named: "like_pressed")!
            favoriteButton.setImage(image1, forState: UIControlState.Highlighted)
            //           favoriteButton.setImage(image1, forState: UIControlState.)
            
        }
        retweetCount.text="\(tweet.retweetCount!)"
        likeCount.text="\(tweet.favoriteCount!)"
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
         if (segue.identifier == "toReply") {
            let vc = segue.destinationViewController as! ComposeViewController
            vc.screenname = tweet.user!.screenname!
            
            
            
        }
    }


}
