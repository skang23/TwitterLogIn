//
//  TweetsViewController.swift
//  TwitterLogIn
//
//  Created by Suyeon Kang on 2/17/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    var tweets: [Tweet]?
    var selectedTweet: Tweet?
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: {(tweets,error)->() in self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()

        })
    }
    
    @IBAction func refreshTweets(sender: AnyObject) {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: {(tweets,error)->() in self.tweets = tweets
            self.tableView.reloadData()

        })
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: {(tweets,error)->() in self.tweets = tweets
            self.tableView.reloadData()

        })
    }
    @IBAction func logOut(sender: AnyObject) {
        User.currentUser?.logout()
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
       // print("cell For Row At Index Path")
       cell.tweet = tweets![indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.profileButton.tag = indexPath.row

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        }
        else{
            return 0
        }
    }
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    selectedTweet = tweets![indexPath.row]
    print("tweet: \(selectedTweet)")
    self.performSegueWithIdentifier("toDetail", sender: self)

        //CODE TO BE RUN ON CELL TOUCH
    }
    
//    @IBAction func imageButtonTapped(sender: AnyObject) {
//        let cell = sender.superview as! TweetCell
//       // cell.tweet
//        print(cell)
//        print(cell.tweet)
//    }
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "toDetail") {
            let vc = segue.destinationViewController as! DetailViewController
            vc.tweet = selectedTweet!
            print("vc: \(vc)")


        }else if (segue.identifier == "compose") {
            let vc = segue.destinationViewController as! ComposeViewController
            vc.screenname = nil
            
            
            
        }else if (segue.identifier == "profile"){
            
            let vc = segue.destinationViewController as! profileViewController
            vc.user = tweets![sender.tag].user
            //  vc.user =
        }
    }

}


