//
//  TweetListViewModel.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import Foundation
import Combine

class TweetListViewModel {
    
    @Published var showLoading: Bool = false
    @Published var tweetViewModels: [TweetViewModel] = []
    
    func streamTweets() {
        showLoading = true
        NetworkAgent.shared.request(TwitterApiService.stream, as: Tweet.self) { [weak self] result in
            guard let self = self else { return }
            self.showLoading = false
            switch result {
            case .success(let tweet):
                let tweetVm = TweetViewModel(tweet: tweet)
                self.tweetViewModels.insert(tweetVm, at: 0)

                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchTextChanged(_ text: String) {
        print(text)
    }
}
