//
//  NetworkAgent.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import Foundation

class NetworkAgent {
    
    static let shared = NetworkAgent()
    
    func request<T: Decodable>(_ request: RequestProtocol, as: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        
        var networkOperation: AsyncOperation
        
        switch request.requestType {
        case .stream:
            networkOperation = NetworkStreamOperation(request: request, responseType: T.self, completion: completion)

        case .data:
            networkOperation = NetworkOperation(request, responseType: T.self, completion: completion)
        }
        
        NetworkQueueManager.shared.enqueue(networkOperation)
    }
}
