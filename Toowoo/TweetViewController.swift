//
//  TweetViewController.swift
//  Toowoo
//
//  Created by David Bowen on 2/22/15.
//  Copyright (c) 2015 David Bowen. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var replyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tweet = Tweet.currentTweet
        let author = tweet!.user!
        userNameLabel.text = author.name!
        tweetLabel.text = tweet!.text
        userProfileImageView.setImageWithURL(NSURL(string: author.profileImageUrl!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onReTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.reTweet(Tweet.currentTweet!) {
            (reTweet: ReTweet?, error: NSError?) -> Void in
            if reTweet != nil {
                println("ReTweet succeeded")
            } else {
                println("ReTweet failed with error \(error)")
            }
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        TwitterClient.sharedInstance.favorite(Tweet.currentTweet!) {
            (response: NSDictionary?, error: NSError?) -> Void in
            if response != nil {
                println("Favorite succeeded")
            } else {
                println("Favorite failed with error \(error)")
            }
        }
    }
    
    @IBAction func onReply(sender: AnyObject) {
        var reply = replyTextView.text
        if reply.isEmpty {
            replyTextView.becomeFirstResponder()
            replyTextView.text = "@\(Tweet.currentTweet!.user!.screenName!) "
        }
        else {
            TwitterClient.sharedInstance.reply(reply, tweet: Tweet.currentTweet!) {
                (reply: Tweet?, error: NSError?) -> Void in
                if reply != nil {
                    println("Reply succeeded")
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    println("Reply failed with error \(error)")
                }
            }
        }
    }

    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
