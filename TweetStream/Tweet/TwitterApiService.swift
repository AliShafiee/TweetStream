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
    case addRules(ids: [String])
    case deleteRules(ids: [String])
    
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
            
        case .addRules(let ids):
            var params = [String: Any?]()
            params["add"] = ids
            return params
            
        case .deleteRules(let ids):
            var params = [String: Any?]()
            
            var idsParams = [String: Any?]()
            idsParams["ids"] = ids
            
            params["delete"] = idsParams
            return params
        }
    }
    
    var requestType: RequestType {
        switch self {
        case .stream:
            return .stream

        default:
            return .data
        }
    }
}
