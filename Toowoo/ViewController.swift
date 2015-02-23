//
//  ViewController.swift
//  Toowoo
//
//  Created by David Bowen on 2/20/15.
//  Copyright (c) 2015 David Bowen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) -> Void in
            if user != nil {
                println("User \(user!.name!) logged in")
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
            else {
                // handle login error
                println("Login error: \(error)")
            }
        }
    }
    
}

