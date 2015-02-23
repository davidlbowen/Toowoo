//
//  ComposeViewController.swift
//  Toowoo
//
//  Created by David Bowen on 2/22/15.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userNameLabel.text = User.currentUser!.name!
        userProfileImage.setImageWithURL(NSURL(string: User.currentUser!.profileImageUrl!))
        tweetTextView.text = ""
        tweetTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.tweet(tweetTextView.text) {
            (tweet: Tweet?, error: NSError?) -> Void in
            if tweet != nil {
                println("Tweet posted, response: \(tweet!)")
            }
            else {
                println("Tweet failed, error: \(error!)")
            }
        }
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
