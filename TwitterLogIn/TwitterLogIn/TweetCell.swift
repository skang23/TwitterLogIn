//
//  TweetCell.swift
//  TwitterLogIn
//
//  Created by Suyeon Kang on 2/18/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var photo: UIImageView!
    var tweet: Tweet! {
        didSet{
            
            profilePhoto.setImageWithURL(NSURL(string: tweet.profilePhoto!)!)
            profileButton.setBackgroundImage(profilePhoto.image, forState: .Normal)
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
        //    profilePhoto.setImageWithURL(t)
         //   nameLabel.text = business.name
         //   if business.imageURL != nil {
         //       thumbImageView.setImageWithURL(business.imageURL!)
         //   }
         //   categoryLabel.text = business.categories
         //   addressLabel.text = business.address
         //   reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
         //   ratingImageView.setImageWithURL(business.ratingImageURL!)
         //   distanceLabel.text=business.distance
        }
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
        
        /*
        POST("1.1/statuses/retweet/\(tweet.tweetID).json", parameters:params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
        // print("home timeline: \(response)")
        
        }, failure: { (operation: NSURLSessionDataTask?, error:NSError) -> Void in
        print("error getting home timeline")
        })
        */
        
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
}

extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}
