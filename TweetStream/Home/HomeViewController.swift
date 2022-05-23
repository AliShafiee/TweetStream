//
//  HomeViewController.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    let tweetListVc = TweetListViewController()
    let coordinator: HomeCoordinator
    @IBOutlet weak var tweetListContainerView: UIView!
    private var subscriptions = Set<AnyCancellable>()

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
        navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Keywords..."
        navigationItem.searchController = searchController
        setupSearchBarListener(searchController)
    }
    
    func setupSearchBarListener(_ searchController: UISearchController) {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification,
                                                             object: searchController.searchBar.searchTextField)
        publisher
            .map { ($0.object as! UISearchTextField).text }
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .sink { [weak self] query in
                guard let self = self, let query = query, !query.isEmpty else { return }
                self.tweetListVc.viewModel.searchTextChanged(query)
            }.store(in: &subscriptions)
    }
}

extension HomeViewController: TweetListDelegate {
    func onTweetSelected(tweetViewModel: TweetViewModel) {
        coordinator.coordinateToTweetDetail(tweetViewModel: tweetViewModel)
    }
}
