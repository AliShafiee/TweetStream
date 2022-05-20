//
//  AppCoordinator.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    private var window: UIWindow
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        coordinateToHome()
    }
    
    private func coordinateToHome() {
        let coordinator = HomeCoordinator(window: window, navigationController: navigationController)
        coordinator.start()
    }
}
