//
//  TweetListViewModel.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import Foundation
import RxSwift

class TweetListViewModel {
    
    let showLoading = PublishSubject<Bool>()
    let tweets = BehaviorSubject<[SectionOfTweet]>(value: [])
    
    func streamTweets() {
        showLoading.onNext(true)
        NetworkAgent.shared.request(TwitterApiService.stream, as: Tweet.self) { [weak self] result in
            guard let self = self else { return }
            self.showLoading.onNext(false)
            switch result {
            case .success(let tweet):
                if var value = try? self.tweets.value().first {
                    value.items.insert(tweet, at: 0)
                    self.tweets.onNext([value])
                } else {
                    self.tweets.onNext([SectionOfTweet(header: "", items: [tweet])])
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
