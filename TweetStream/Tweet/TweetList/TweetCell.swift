//
//  TweetCell.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var labelBackground: UIView!
    @IBOutlet weak var tweetLabel: UILabel!
    
    func setupView(tweetViewModel: TweetViewModel, animated: Bool) {
        tweetLabel.text = tweetViewModel.text
      
        guard animated else { return }
        labelBackground.backgroundColor = UIColor(red: 85.0/255.0, green: 211.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseInOut) { [weak self] in
            guard let self = self else { return }
            self.labelBackground.backgroundColor = .white
        }
    }
    
}
