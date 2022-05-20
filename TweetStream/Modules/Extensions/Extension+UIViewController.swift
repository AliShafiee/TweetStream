//
//  Extension+UIViewController.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit

extension UIViewController {
    
    func replaceChilds(containerView: UIView? = nil, newChild: UIViewController, oldChild: UIViewController, completion: ((Bool) -> Void)? = nil) {
        removeChild(child: oldChild)
        addChild(to: containerView, child: newChild) { success in
            completion?(success)
        }
    }
    
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
    
    func removeChild(child: UIViewController) {
        for controller in self.children {
            if type(of: controller) == type(of: child) {
                
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .transitionCrossDissolve, animations: {
                    controller.view.alpha = 0.0
                }) { _ in
                    controller.view.removeFromSuperview()
                    controller.removeFromParent()
                    controller.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
}
