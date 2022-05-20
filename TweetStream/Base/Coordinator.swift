//
//  Coordinator.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}

extension Coordinator {
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
}
