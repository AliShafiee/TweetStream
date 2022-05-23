//
//  HomeViewController.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit

class HomeViewController: UIViewController {

    let tweetListVc = TweetListViewController()
    let coordinator: HomeCoordinator
    @IBOutlet weak var tweetListContainerView: UIView!
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTweetList()
        setupNav()
    }
    
    func setupTweetList() {
        addChild(to: tweetListContainerView, child: tweetListVc)
        tweetListVc.delegate = self
    }
    
    func setupNav() {
        title = "Tweet Stream"
        let searchController = UISearchController(searchResultsController: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
        let tweetListVc = searchController.searchResultsController as? TweetListViewController else { return }
        tweetListVc.viewModel.searchTextChanged(text)
    }
}

extension HomeViewController: TweetListDelegate {
    func onTweetSelected(tweet: Tweet) {
        coordinator.coordinateToTweetDetail(tweet: tweet)
    }
}
