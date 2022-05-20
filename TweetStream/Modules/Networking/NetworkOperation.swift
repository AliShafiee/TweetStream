//
//  NetworkOperation.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import Foundation

class NetworkOperation<T: Decodable>: AsyncOperation {
        
    internal var session: URLSession!
    internal let decoder: JSONDecoder
    var task: URLSessionTask?
    
    var request: RequestProtocol
    let responseType: T.Type
    let completionHandler: (Result<T, APIError>) -> Void
    
    init(_ request: RequestProtocol, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        self.request = request
        self.responseType = responseType
        self.completionHandler = completion
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 20
        config.timeoutIntervalForRequest = 20
        if #available(iOS 11, *) {
            config.waitsForConnectivity = false
        }
        self.session = URLSession(configuration: config, delegate: nil, delegateQueue: .main)
        self.decoder = JSONDecoder()
        
        super.init()
    }
    
    override func main() {
        attemptRequest()
    }
    
    private func attemptRequest() {
        do {
            try createTask(request.asURLRequest())
        } catch {
            defer { self.state = .finished }
            completionHandler(.failure(APIError.urlRequestError))
        }
    }
    
    private func createTask(_ urlRequest: URLRequest) {
        print("URL: \(urlRequest)\nParams: \(request.parameters ?? ["": ""])\nHeaders: \(request.requestHeaders ?? ["": ""])")
        
        task = session.dataTask(with: urlRequest, completionHandler: { [weak self] (data, urlResponse, error) in
            self?.validateDataResponse(data: data, urlResponse: urlResponse, error: error)
        })
        
        task?.resume()
    }
    
    private func validateDataResponse(data: Data?, urlResponse: URLResponse?, error: Error?) {
        
        do {
            if let error = error {
                throw error.APIError()
            }
            
            guard let data = data else { throw APIError.noData }
            guard let urlResponse = urlResponse as? HTTPURLResponse else { throw APIError.invalidResponse }
            
            try validateStatusCode(data: data, urlResponse: urlResponse, error: error)
            do {
                let result = try decoder.decode(T.self, from: data)
                
                defer { self.state = .finished }
                completionHandler(.success(result))
            } catch {
                print("\(error)\nerror in decoding = \(String(data: data, encoding: .utf8) ?? "") - \(T.self)")
                throw APIError.decodingError
            }
        } catch {
            guard let error = error as? APIError else { return }
            completionHandler(.failure(error))
        }
    }
    
    internal func validateStatusCode(data: Data? = nil, urlResponse: HTTPURLResponse, error: Error?) throws {
        switch urlResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw APIError.tokenError
        case 400...499:
            throw APIError.badRequest(msg: "bad request!!!", status: urlResponse.statusCode)
        case 500...599:
            throw APIError.serverError(msg: "server error!!!", status: urlResponse.statusCode)
        default:
            throw APIError.unknown
        }
    }
    
    func cancelTask() {
        task?.cancel()
    }
    
    deinit {
        session.invalidateAndCancel()
        session = nil
    }
}
