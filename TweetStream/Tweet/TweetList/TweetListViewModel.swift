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
            switch result {
            case .success(let tweet):
                self.showLoading = false
                let tweetVm = TweetViewModel(tweet: tweet)
                self.tweetViewModels.insert(tweetVm, at: 0)

            case .failure(let error):
                print(error)
                switch error {
                case .decodingError:
                    break
                    
                default:
                    self.showLoading = false

                }
            }
        }
    }
    
    func searchTextChanged(_ text: String) {
        print(text)
    }
}
