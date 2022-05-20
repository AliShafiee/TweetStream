//
//  AppDelegate.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupRootController()
        return true
    }

    func setupRootController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationController = UINavigationController()
        
        appCoordinator = AppCoordinator(window: window!, navigationController: navigationController!)
        appCoordinator?.start()
    }
}

