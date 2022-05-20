//
//  TweetDetailViewController.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var tweetLabel: UILabel!
    
    let tweet: Tweet
    
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetLabel.text = tweet.text
    }

}
