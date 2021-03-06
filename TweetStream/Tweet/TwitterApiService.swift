//
//  TwitterApiService.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import Foundation

enum TwitterApiService: RequestProtocol {
    
    case stream
    case retrieveRules
    case deleteRules(rules: [TweetStreamRule])
    case addRules(rules: [TweetStreamRule])
    
    var path: String {
        switch self {
        case .stream:
            return "2/tweets/search/stream"
            
        case .retrieveRules:
            return "2/tweets/search/stream/rules"
            
        case .addRules:
            return "2/tweets/search/stream/rules"
            
        case .deleteRules:
            return "2/tweets/search/stream/rules"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .stream:
            return .get
            
        case .retrieveRules:
            return .get
            
        case .addRules:
            return .post
            
        case .deleteRules:
            return .post
        }
    }
    
    var parameters: RequestParameters? {
        switch self {
        case .stream:
            return nil
            
        case .retrieveRules:
            return nil
            
        case .addRules(let rules):
            var params = [String: Any?]()
            
            var rulesParams = [[String: Any?]]()
            for rule in rules {
                if let value = rule.value, !value.isEmpty {
                    var ruleParam = [String: Any?]()
                    ruleParam["value"] = value
                    rulesParams.append(ruleParam)
                }
            }
            params["add"] = rulesParams
            return params
            
        case .deleteRules(let rules):
            var params = [String: Any?]()
            var idsParams = [String: Any?]()
            idsParams["ids"] = rules.compactMap({ $0.id })
            params["delete"] = idsParams
            return params
        }
    }
    
    var queryParameters: QueryParameters? {
        switch self {
        case .stream:
            return ["expansions": "author_id",
                    "user.fields": "name,username"]
            
        default:
            return nil
        }
    }
    
    var requestType: RequestType {
        switch self {
        case .stream:
            return .stream(throttleDuration: 3)
            
        default:
            return .data
        }
    }
}
