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
    private var subscriptions = Set<AnyCancellable>()
    private var throttleDuration: Double

    init(request: RequestProtocol, responseType: T.Type, throttleDuration: Double, completion: @escaping (Result<T, APIError>) -> Void) {
        self.request = request
        self.responseType = responseType
        self.completionHandler = completion
        self.decoder = JSONDecoder()
        self.throttleDuration = throttleDuration
        super.init()
    }
    
    override func main() {
        attemptRequest()
    }
    
    func attemptRequest() {
        session.streamRequest(request)
            .validate()
            .publishData()
            .throttle(for: .seconds(throttleDuration), scheduler: DispatchQueue.main, latest: true).sink { stream in
                switch stream.result {
                case .success(let data):
                    do {
                        let result = try self.decoder.decode(T.self, from: data)
                        self.completionHandler(.success(result))
                    } catch {
//                        print("\(error)\nerror in decoding = \(String(data: data, encoding: .utf8) ?? "") - \(T.self)")
                        self.completionHandler(.failure(.decodingError))
                    }
                case .failure(let error):
                    self.completionHandler(.failure(error.APIError()))
                    
                case .none:
                    stream.cancel()
                    self.attemptRequest()
                }
            }.store(in: &subscriptions)
    }
}
