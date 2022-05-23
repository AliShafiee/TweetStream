//
//  TweetViewModel.swift
//  TweetStream
//
//  Created by Ali Shafiee on 3/2/1401 AP.
//

import Foundation

struct TweetViewModel {
    let text: String
    
    init(tweet: Tweet) {
        self.text = tweet.text
    }
}
