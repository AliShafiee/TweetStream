//
//  HomeCoordinator.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    private var window: UIWindow
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        let homeVc = HomeViewController(coordinator: self)
        self.navigationController.setViewControllers([homeVc], animated: true)
        self.window.rootViewController = self.navigationController
        window.makeKeyAndVisible()
    }
    
    func coordinateToTweetDetail(tweet: Tweet) {
        let coordinator = TweetDetailCoordinator(navigationController: navigationController, tweet: tweet)
        coordinator.start()
    }
}
