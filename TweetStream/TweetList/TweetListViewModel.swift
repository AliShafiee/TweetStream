//
//  TweetListViewModel.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import Foundation
import RxSwift

class TweetListViewModel {
    
    let tweets = BehaviorSubject<[Tweet]>(value: [])
    
    func streamTweets() {
        NetworkAgent.shared.request(TwitterApiService.stream, as: Tweet.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let tweet):
                if var value = try? self.tweets.value() {
                    value.insert(tweet, at: 0)
                    self.tweets.onNext(value)
                } else {
                    self.tweets.onNext([tweet])
                }

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
