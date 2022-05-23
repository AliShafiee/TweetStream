//
//  TweetDetailViewController.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    let tweetViewModel: TweetViewModel
    
    init(tweetViewModel: TweetViewModel) {
        self.tweetViewModel = tweetViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        setupView()
    }
    
    func setupNav() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupView() {
        tweetLabel.text = tweetViewModel.text
        if let name = tweetViewModel.name,
           let userName = tweetViewModel.username {
            nameLabel.text = name
            userNameLabel.text = userName
        } else {
            nameLabel.isHidden = true
            userNameLabel.isHidden = true
        }
    }
}
