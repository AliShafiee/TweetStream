//
//  TweetListViewController.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit
import Combine

protocol TweetListDelegate: NSObject {
    func onTweetSelected(tweetViewModel: TweetViewModel)
}

class TweetListViewController: UIViewController {

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    let viewModel = TweetListViewModel()
    let cellReuseId = "tweetCellReuseId"
    weak var delegate: TweetListDelegate?
    var showedTweetsIndex = Set<Int>()
    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupBinding()
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 16.0, left: 0.0, bottom: 32.0, right: 0.0)
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "TweetCell", bundle: Bundle.main), forCellReuseIdentifier: cellReuseId)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupBinding() {
        viewModel.$tweetViewModels
           .receive(on: DispatchQueue.main)
           .sink { [weak self] items in
               guard let self = self else { return }
               if self.viewModel.tweetViewModels.isEmpty {
                   self.tableView.reloadData()
                   return
               }
               self.tableView.beginUpdates()
               self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
               self.tableView.endUpdates()
           }
           .store(in: &subscriptions)
        
        viewModel.$showLoading
           .receive(on: DispatchQueue.main)
           .sink { [weak self] showLoading in
               guard let self = self else { return }
               if showLoading {
                   self.loadingView.isHidden = false
               } else {
                   self.loadingView.isHidden = true
               }
           }
           .store(in: &subscriptions)
        
        viewModel.streamTweets()
    }

}

extension TweetListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweetViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! TweetCell
        cell.setupView(tweetViewModel: viewModel.tweetViewModels[indexPath.row], animated: indexPath.row == 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.onTweetSelected(tweetViewModel: viewModel.tweetViewModels[indexPath.row])
    }
}
