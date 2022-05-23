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
    @Published var rulesUpdated: Bool = false
    
    func streamTweets(completion: ((Result<[TweetStreamRule], APIError>) -> Void)? = nil) {
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
    
    func retrieveRulesFromServer(completion: @escaping (Result<[TweetStreamRule], APIError>) -> Void) {
        NetworkAgent.shared.request(TwitterApiService.retrieveRules, as: TweetStreamRuleResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data ?? []))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteRulesFromServer(rules: [TweetStreamRule], completion: @escaping (Result<Bool, APIError>) -> Void) {
        NetworkAgent.shared.request(TwitterApiService.deleteRules(rules: rules), as: EmptyResponse.self) { result in
            switch result {
            case .success:
                completion(.success(true))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addRuleToServer(value: String, completion: @escaping (Result<Bool, APIError>) -> Void) {
        let rule = TweetStreamRule(id: nil, value: value, tag: nil)
        NetworkAgent.shared.request(TwitterApiService.addRules(rules: [rule]), as: EmptyResponse.self) { result in
            switch result {
            case .success:
                completion(.success(true))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateRules(newVal: String) {
        showLoading = true
        retrieveRulesFromServer { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let rules):
                print("current rules: \(rules)")
                self.deleteRules(newVal: newVal, rules: rules)
                
            case .failure(let error):
                self.showLoading = false
                print(error)
            }
        }
    }
    
    func deleteRules(newVal: String, rules: [TweetStreamRule]) {
        guard rules.count > 0 else {
            addRule(newVal: newVal)
            return
        }
        deleteRulesFromServer(rules: rules) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.addRule(newVal: newVal)
                
            case .failure(let error):
                self.showLoading = false
                print(error)
            }
        }
    }
    
    func addRule(newVal: String) {
        addRuleToServer(value: newVal) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.rulesUpdated = true
                self.showLoading = false
                
            case .failure(let error):
                self.showLoading = false
                print(error)
            }
        }
    }
    
    func searchTextChanged(_ text: String) {
        updateRules(newVal: text)
    }
}
