//
//  TweetViewModel.swift
//  TweetStream
//
//  Created by Ali Shafiee on 3/2/1401 AP.
//

import Foundation

struct TweetViewModel {
    let text: String
    let name: String?
    let username: String?
    
    init(tweet: Tweet) {
        self.text = tweet.text
        self.name = tweet.users.first?.name
        if let userName = tweet.users.first?.username {
            self.username = "@\(userName)"
        } else {
            self.username = nil
        }
    }
}
