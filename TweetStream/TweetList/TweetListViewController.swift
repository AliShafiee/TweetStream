//
//  TweetListViewController.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol TweetListDelegate: NSObject {
    func onTweetSelected(tweet: Tweet)
}

class TweetListViewController: UIViewController {

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    let viewModel = TweetListViewModel()
    let cellReuseId = "tweetCellReuseId"
    let disposeBag = DisposeBag()
    weak var delegate: TweetListDelegate?
    
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
    }
    
    func setupBinding() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SectionOfTweet>(
            decideViewTransition: { _, _, _ in
                return .animated
            }, configureCell: {_, tableView, indexPath, tweet in
                let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseId, for: indexPath) as! TweetCell
                cell.setupView(tweetText: tweet.text)
                return cell
            })
        
        viewModel
            .tweets
            .asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(Tweet.self)
            .asObservable()
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] tweet in
                guard let self = self else { return }
                self.delegate?.onTweetSelected(tweet: tweet)
            }).disposed(by: disposeBag)
        
        viewModel
            .showLoading
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] showLoading in
                guard let self = self else { return }
                if showLoading {
                    self.loadingView.isHidden = false
                } else {
                    self.loadingView.isHidden = true
                }
        }).disposed(by: disposeBag)
        
        viewModel.streamTweets()
    }

}
