//
//  User.swift
//  Toowoo
//
//  Created by David Bowen on 2/21/15.
//  Copyright (c) 2015 David Bowen. All rights reserved.
//

import Foundation

// global variable hack - no static fields in Swift yet
var _currentUser: User?
let _currentUserKey = "currentUserKey"
let _userDidLoginNotification = "userDidLoginNotification"
let _userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
   
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    class func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(_userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(_currentUserKey) as? NSData
                if data != nil {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            var data = user == nil ? nil :
                NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
            
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: _currentUserKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
