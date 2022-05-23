//
//  TweetDetailCoordinator.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit

class TweetDetailCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    let tweet: Tweet
    
    init(navigationController: UINavigationController, tweet: Tweet) {
        self.navigationController = navigationController
        self.tweet = tweet
    }
    
    func start() {
        let vc = TweetDetailViewController(tweet: tweet)
        navigationController.pushViewController(vc, animated: true)
    }
    
}
