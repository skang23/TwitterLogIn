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

    class var sharedInstance:TwitterClient {
        struct Static{
            static let instance = TwitterClient(baseURL:twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
}
