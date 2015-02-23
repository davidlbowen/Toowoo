//
//  Tweet.swift
//  Toowoo
//
//  Created by David Bowen on 2/21/15.
//

import Foundation

var _currentTweet : Tweet?

class Tweet: NSObject {
   
    var id: String!
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        id = dictionary["id_str"] as String!
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
    class var currentTweet: Tweet? {
        get {
            return _currentTweet
        }
        set(tweet) {
            _currentTweet = tweet
        }
    }

}
