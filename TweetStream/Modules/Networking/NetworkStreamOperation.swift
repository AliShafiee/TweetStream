//
//  NetworkStreamOperation.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import Foundation
import Alamofire
import Combine

class NetworkStreamOperation<T: Decodable>: AsyncOperation {
        
    internal var session: Session = Session(configuration: .default)
    internal var request: RequestProtocol!
    let responseType: T.Type
    let completionHandler: (Result<T, APIError>) -> Void
    internal let decoder: JSONDecoder
    var requestsCancellable: Set<AnyCancellable> = []

    init(request: RequestProtocol, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        self.request = request
        self.responseType = responseType
        self.completionHandler = completion
        self.decoder = JSONDecoder()
        super.init()
    }
    
    override func main() {
        attemptRequest()
    }
    
    func attemptRequest() {
        session.streamRequest(request)
            .publishDecodable(type: T.self)
            .throttle(for: .seconds(5), scheduler: DispatchQueue.main, latest: true ).sink { stream in
            switch stream.result {
            case .success(let data):
                self.completionHandler(.success(data))

            case .failure(let error):
                print(error)

            case .none:
                stream.cancel()
                self.attemptRequest()
            }
        }.store(in: &requestsCancellable)
    }
}
