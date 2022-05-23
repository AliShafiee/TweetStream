//
//  Extension+UIViewController.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit

extension UIViewController {
    
    func addChild(to containerView: UIView? = nil, child: UIViewController, duration: Double = 0.3, completion: ((Bool) -> Void)? = nil) {
        
        let container = ((containerView != nil) ? containerView! : view!)
        container.isHidden = false
        container.isUserInteractionEnabled = true
        var has = false
        for ch in children {
            if ch == child {
                has = true
            }
        }
        
        if !has {
            addChild(child)
            let newView = child.view!
            newView.translatesAutoresizingMaskIntoConstraints = true
            newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            newView.frame = container.bounds
            container.addSubview(newView)
            
            child.view.alpha = 0.0
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .transitionCrossDissolve, animations: {
                child.view.alpha = 1.0
            }) { (done) in
                child.didMove(toParent: self)
                completion?(done)
            }
        }
    }
}
