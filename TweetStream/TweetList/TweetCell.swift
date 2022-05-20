//
//  TweetCell.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetLabel: UILabel!
    
    func setupView(tweetText: String) {
        tweetLabel.text = tweetText
    }
    
}
