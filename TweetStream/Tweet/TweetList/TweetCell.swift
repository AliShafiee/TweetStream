//
//  TweetCell.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var contentBackground: UIView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var userNameContainerView: UIView!
    
    func setupView(tweetViewModel: TweetViewModel, animated: Bool) {
        tweetLabel.text = tweetViewModel.text
        if let name = tweetViewModel.name,
           let userName = tweetViewModel.username {
            nameLabel.text = name
            idLabel.text = userName
            userNameContainerView.isHidden = false
        } else {
            userNameContainerView.isHidden = true
        }
       
        guard animated else { return }
        contentBackground.backgroundColor = UIColor(red: 85.0/255.0, green: 211.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseInOut) { [weak self] in
            guard let self = self else { return }
            self.contentBackground.backgroundColor = .white
        }
    }
    
}
