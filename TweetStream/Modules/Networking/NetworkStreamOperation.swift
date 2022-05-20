//
//  NetworkStreamOperation.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import Foundation
import Alamofire

class NetworkStreamOperation<T: Decodable>: AsyncOperation {
        
    internal var session: Session = Session(configuration: .default)
    internal var request: RequestProtocol!
    let responseType: T.Type
    let completionHandler: (Result<T, APIError>) -> Void
    internal let decoder: JSONDecoder

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
        session.streamRequest(request).responseStream { stream in
            switch stream.result {
            case .success(let data):
                let result = try self.decoder.decode(T.self, from: data)
                self.completionHandler(.success(result))
                print(result)
                
            case .failure(let error):
                print(error)
                
            case .none:
                break
            }
        }
    }
}
