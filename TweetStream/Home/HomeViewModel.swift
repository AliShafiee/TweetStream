//
//  HomeViewModel.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    let tweets = BehaviorSubject<[Tweet]>(value: [])
    
    func getLiveData() {
        NetworkAgent.shared.request(TwitterApiService.stream, as: Tweet.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let tweet):
                if var value = try? self.tweets.value() {
                    value.append(tweet)
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
    
}
