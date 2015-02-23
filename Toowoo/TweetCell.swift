//
//  TweetCell.swift
//  Toowoo
//
//  Created by David Bowen on 2/21/15.
//

import UIKit

class TweetCell: UITableViewCell {


    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tweetTextLabel.preferredMaxLayoutWidth = 250
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTweet(tweet: Tweet) {
        authorLabel.text = tweet.user!.name!
        tweetTextLabel.text = tweet.text
        
        datetimeLabel.text = timeInterval(tweet.createdAt!)
        
        authorImageView.setImageWithURL(
            NSURL(string: tweet.user!.profileImageUrl!))
    }
    
    func timeInterval(datetime: NSDate) -> String {
        var seconds = -datetime.timeIntervalSinceNow as Double
        if seconds < 60 {
            return "\(Int(seconds))s"
        }
        else if seconds < 3600 {
            return "\(Int(seconds/60))m"
        }
        else if seconds < 3600 * 24 {
            return "\(Int(seconds/3600))h"
        }
        else {
            return "\(Int(seconds/(3600 * 24)))d"
        }
    }

}
