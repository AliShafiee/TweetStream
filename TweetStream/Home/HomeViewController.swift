//
//  HomeViewController.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit

class HomeViewController: UIViewController {

    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
    }
    
    func setupNav() {
        title = "Tweet Stream"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
}
