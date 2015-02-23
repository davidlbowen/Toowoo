//
//  TweetsViewController.swift
//  Toowoo
//
//  Created by David Bowen on 2/21/15.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var tweetTableView: UITableView!
    var tweets: [Tweet] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTableView.dataSource = self
        tweetTableView.delegate = self
        tweetTableView.estimatedRowHeight = 50
        tweetTableView.rowHeight = UITableViewAutomaticDimension
        
        fetchHomeTimeline() { () -> Void in println("Loaded tweets") }
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tweetTableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func fetchHomeTimeline(onCompletion: () -> Void) {
        SVProgressHUD.show()
        TwitterClient.sharedInstance.fetchHomeTimeline(nil,
            completion: { (tweets: [Tweet]?, error: NSError?) -> Void in
                if tweets != nil {
                    self.tweets = tweets!
                    self.tweetTableView.reloadData()
                    onCompletion()
                } else {
                    println("Error fetching tweets: \(error)")
                }
                SVProgressHUD.dismiss()
            }
        )
    }
    
    // Refreshing
    
    func onRefresh() {
        fetchHomeTimeline() { () -> Void in
            println("Reloaded tweets");
            self.refreshControl.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCompose(sender: AnyObject) {
        println("onCompose")
        performSegueWithIdentifier("composeSegue", sender: self)
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        println("onLogout")
        User.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as TweetCell
        cell.setTweet(tweets[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Tweet.currentTweet = tweets[indexPath.row]
        performSegueWithIdentifier("tweetSegue", sender: self)
    }
    
    // This does not work.  Worked around it by using Tweet.currentTweet to pass the tweet instead.

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if "tweetSegue" == segue.identifier {
            if let tweetVC = segue.destinationViewController as? TweetViewController {
                println("Prepare for segue to TweetViewController")
                let selectedRow = tweetTableView.indexPathForSelectedRow()!.row
                tweetVC.tweet = tweets[selectedRow]
            }
            else {
                println("Prepare for segue failed. What went wrong?")
            }
        }
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
