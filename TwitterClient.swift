//
//  TwitterClient.swift
//  Toowoo
//
//  Created by David Bowen on 2/20/15.
//

import UIKit

let twitterConsumerKey = "TgLJEAkkV9Zf4YL9cMuAAYHw3"
let twitterConsumerSecret = "zV4dSNV7mj1HXTsZQ5LnyBUHBND2Wp50tRiothhmASTV8av6Nk"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(
                baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    var loginCompletion: ((user: User?, error: NSError?) -> Void)?
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> Void) {
        loginCompletion = completion
        
        // Fetch request token and redirect to authorization page
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "toowoo://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                println("Got the request token")
                var authURL = NSURL(string:
                    "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            },
            failure: { (error: NSError!) -> Void in
                self.loginFailed(error)
            }
        )
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath(
            "oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                self.gotAccessToken(accessToken)            },
            failure: { (error: NSError!) -> Void in
                self.loginFailed(error)
            }
        )
    }
    
    func gotAccessToken(accessToken: BDBOAuth1Credential!) -> Void {
        println("Got the access token")
        requestSerializer.saveAccessToken(accessToken)
        
        GET("1.1/account/verify_credentials.json",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                self.loginSucceeded(user)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error getting current user")
                self.loginFailed(error)
            }
        )
    }
    
    func loginSucceeded(user: User) {
        loginCompletion?(user: user, error: nil)
    }
    
    func loginFailed(error: NSError!) {
        loginCompletion?(user: nil, error: error)
    }
    

    func fetchHomeTimeline(parameters: AnyObject?, completion: (tweets: [Tweet]?, error: NSError?) -> Void) {
        GET("1.1/statuses/home_timeline.json",
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                completion(tweets: tweets, error: nil)
            },
            failure: { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(tweets: nil, error: error)
            }
        )
    }
    
    func tweet(status: String!, completion: (tweet: Tweet?, error: NSError?) -> Void) {
        var parameters = ["status" : status]
        postStatusUpdate(parameters, completion: completion)
    }
    
    func reply(status: String!, tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> Void) {
        var parameters = ["status" : status, "in_reply_to_status_id": tweet.id]
        postStatusUpdate(parameters, completion: completion)
    }

    func postStatusUpdate(parameters: AnyObject?, completion: (tweet: Tweet?, error: NSError?) -> Void) {
        POST("1.1/statuses/update.json",
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let tweet = Tweet(dictionary: response as NSDictionary!)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(tweet: nil, error: error)
            }
        )
    }
    
    func reTweet(tweet: Tweet!, completion: (reTweet: ReTweet?, error: NSError?) -> Void) {
        POST("1.1/statuses/retweet/\(tweet.id).json",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let reTweet = ReTweet(dictionary: response as NSDictionary!)
                completion(reTweet: reTweet, error: nil)
            },
            failure: { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(reTweet: nil, error: error)
            }
        )
    }
    
    func favorite(tweet: Tweet!, completion: (response: NSDictionary?, error: NSError?) -> Void) {
        POST("https://api.twitter.com/1.1/favorites/create.json",
            parameters: ["id": tweet.id],
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                completion(response: response as NSDictionary!, error: nil)
            },
            failure: { (operation:AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(response: nil, error: error)
            }
        )
    }

}
