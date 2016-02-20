
//
//  User.swift
//  TwitterLogIn
//
//  Created by Suyeon Kang on 2/17/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

import UIKit
var _currentUser: User?

let currentUserKey = "kCurrentUserKey"

let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    func logout(){
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        //nsnotification send out broadcast
        //lot of view controllers active
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
     //   NSNotificationCenter.defaultCenter().postNotification(userDidLogoutNotification)
        
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil{
                    do{
        var dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue:0)) as! NSDictionary
        _currentUser = User(dictionary: dictionary)
                    } catch {
        print("failed to serialize2")
        }
        }
            }
        
            return _currentUser
        }
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                do{
                let data=try NSJSONSerialization.dataWithJSONObject(user!.dictionary,options: NSJSONWritingOptions(rawValue:0))
                     NSUserDefaults.standardUserDefaults().setObject((data), forKey: currentUserKey )
                }catch{
                    print("failed to serialize")
                }
               // let data = try NSJSONSerialization.JSONObjectWithData(user!.dictionary,
               //     options:NSJSONReadingOptions(rawValue:0)) as? [String:AnyObject]
               
            }else{
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey )
            }
            NSUserDefaults.standardUserDefaults().synchronize()

        }
    }
}
