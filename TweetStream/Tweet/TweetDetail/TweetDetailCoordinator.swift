//
//  TweetDetailCoordinator.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit

class TweetDetailCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    let tweetViewModel: TweetViewModel
    
    init(navigationController: UINavigationController, tweetViewModel: TweetViewModel) {
        self.navigationController = navigationController
        self.tweetViewModel = tweetViewModel
    }
    
    func start() {
        let vc = TweetDetailViewController(tweetViewModel: tweetViewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
