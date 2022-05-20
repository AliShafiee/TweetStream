//
//  NetworkQueueManager.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import Foundation

class NetworkQueueManager {

    static let shared = NetworkQueueManager()
    
    lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        return queue
    }()
    
    func enqueue(_ operation: Operation) {
        queue.addOperation(operation)
    }
    
    func addOperations(_ operations: [Operation]) {
        queue.addOperations(operations, waitUntilFinished: true)
    }
}
