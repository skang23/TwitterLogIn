//
//  Tweet.swift
//  TwitterLogIn
//
//  Created by Suyeon Kang on 2/17/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var dict: NSDictionary
    var profilePhoto: String?
    var retweeted: Int?
    var favorited: Int?
    var tweetID: Int?
    var retweetCount: Int?
    var favoriteCount: Int?
    init(dictionary: NSDictionary){
        user=User(dictionary: dictionary["user"] as! NSDictionary)
        dict = dictionary
        text=dictionary["text"] as? String
        createdAtString=dictionary["created_at"] as? String
        let formatter = NSDateFormatter()//expensive. make it static
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        profilePhoto = user!.profileImageUrl
        retweeted = dictionary["retweeted"] as? Int
        favorited = dictionary["favorited"] as? Int
        tweetID = dictionary["id"] as? Int
        retweetCount = dictionary["retweet_count"] as? Int
        favoriteCount = dictionary["favorite_count"] as? Int
        
        
    }
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array{
            tweets.append(Tweet(dictionary: dictionary))
            print(dictionary["user"]?["name"])

            print(dictionary["text"])
            
        }
        return tweets
    }
}
