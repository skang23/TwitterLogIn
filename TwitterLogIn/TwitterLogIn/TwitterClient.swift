//
//  TwitterClient.swift
//  TwitterLogIn
//
//  Created by Suyeon Kang on 2/15/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

//import Cocoa
import AFNetworking
import BDBOAuth1Manager

let twitterConsumerKey = "yka2dqMRxPvftbo8BdycHxrpw"
let twitterConsumerSecret = "lMFiSNBze85zsNRsqpOj4I843WJoJvDX9wAxula4c4SLmqLmV0"
let twitterBaseURL = NSURL(string:"https://api.twitter.com")
class TwitterClient: BDBOAuth1SessionManager {
    var loginCompletion: ((user: User?, error: NSError?)->())?
    class var sharedInstance:TwitterClient {
        struct Static{
            static let instance = TwitterClient(baseURL:twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets:[Tweet]?, error: NSError?) ->()){
        
        
        GET("1.1/statuses/home_timeline.json", parameters:params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            // print("home timeline: \(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            for tweet in tweets {
                //    print("text:\(tweet.text), created: \(tweet.createdAt)")
            }
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error:NSError) -> Void in
                print("error getting home timeline")
        })
        
    }
    
    func favoriteTweet(tweet: Tweet, params: NSDictionary?, completion: () ->()) {
        POST("1.1/favorites/create.json", parameters:params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Favorited tweet: \(tweet.tweetID)")
            tweet.favorited = 1
            let dict = response as! NSDictionary
            tweet.favoriteCount = tweet.favoriteCount! + 1
            completion()
            /*
            let image = UIImage(named: "liked")!
            self.favoriteButton.setImage(image, forState: UIControlState.Normal)
            print(response)*/
            
            /*
            self.likeCount.text = "\(tweet.favoriteCount!)"
            */
            }, failure: { (operation: NSURLSessionDataTask?, error:NSError) -> Void in
                print("Failed to favorite: \(error)")
        })
    }
    func retweetWithId(tweet: Tweet, params: NSDictionary?, completion: () ->()) {
        POST("1.1/statuses/retweet/\(tweet.tweetID!).json", parameters:params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Retweeted tweet: \(tweet.tweetID)")
            let image = UIImage(named: "retweeted")!
            tweet.retweeted = 1
            let dict = response as! NSDictionary
            tweet.retweetCount = dict["retweet_count"] as! Int
            completion()
            
            
            }, failure: { (operation: NSURLSessionDataTask?, error:NSError) -> Void in
                print("Failed to retweet: \(error)")
        })
    }

    
    func unretweetWithId(tweet: Tweet, params: NSDictionary?, completion: () ->()) {

        POST("1.1/statuses/unretweet/\(tweet.tweetID!).json", parameters:params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Unretweeted tweet: \(tweet.tweetID)")
            let image = UIImage(named: "retweeted")!
            tweet.retweeted = 0
            let dict = response as! NSDictionary
            tweet.retweetCount = dict["retweet_count"] as! Int - 1
            print(dict["retweet_count"])
            completion()
        
            
            
            }, failure: { (operation: NSURLSessionDataTask?, error:NSError) -> Void in
                print("Failed to unretweet: \(error)")
        })
    }

    
    func unfavoriteTweet(tweet: Tweet, params: NSDictionary?, completion: () ->()) {
        POST("1.1/favorites/destroy.json", parameters:params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Unfavorited tweet: \(tweet.tweetID)")
            tweet.favorited = 0
            let dict = response as! NSDictionary
            tweet.favoriteCount = tweet.favoriteCount! - 1
            completion()
         
            }, failure: { (operation: NSURLSessionDataTask?, error:NSError) -> Void in
                print("Failed to unfavorite: \(error)")
        })
    }
    
    
    func statusUpdateWithParams(params: NSDictionary?){
        
        
       POST("1.1/statuses/update.json", parameters:params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("status update")

            }, failure: { (operation: NSURLSessionDataTask?, error:NSError) -> Void in
                print("error getting home timeline")
        })
        
    }
    
    
    func replyWithParams(params: NSDictionary?){
        
        
        POST("1.1/direct_messages/new.json", parameters:params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("direct_message")
            
            }, failure: { (operation: NSURLSessionDataTask?, error:NSError) -> Void in
                print("faild to message")
        })
        
    }
    
    func openURL(url: NSURL){
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
      
            
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                //  print("user: \(response)")
                let user = User(dictionary: response as! NSDictionary)
                print("user: \(user.name)")
                User.currentUser=user
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error:NSError) -> Void in
                    print("error getting current user")
            })            }) { (error:NSError!) -> Void in
                print("failed to receive access token")
                self.loginCompletion?(user:nil, error: error)

        }

    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()){
     loginCompletion = completion
        
        //fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"cptwitterdemo://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion?(user:nil, error: error)
        }
        
    }
}
