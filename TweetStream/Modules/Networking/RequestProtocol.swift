//
//  RequestProtocol.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import Foundation
import Alamofire

typealias ReaquestHeaders = [String: String]
typealias RequestParameters = [String: Any?]
typealias QueryParameters = [String: Any?]

public enum RequestType {
    case data
    case stream
}

protocol RequestProtocol: URLRequestConvertible {
    var baseUrl: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var requestHeaders: ReaquestHeaders? { get }
    var parameters: RequestParameters? { get }
    var queryParameters: QueryParameters? { get }
    var requestType: RequestType { get }
}

extension RequestProtocol {
    var baseUrl: String {
        return "https://api.twitter.com/"
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var requestHeaders: ReaquestHeaders? {
        return ["Authorization": "Bearer \(getBearerToken())",
                "Content-Type": "application/json"]
    }
    
    var parameters: RequestParameters? {
        return nil
    }
    
    var queryParameters: QueryParameters? {
        return nil
    }
    
    var requestType: RequestType {
        return .data
    }
}

extension RequestProtocol {
    
    func asURLRequest() throws -> URLRequest {
        let url = url(with: baseUrl)
        var request = URLRequest(url: url!)
        
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = jsonBody
        
        return request
    }
    
    private func url(with baseURL: String) -> URL? {
        guard var urlComponents = URLComponents(string: baseURL) else {
            return nil
        }
        urlComponents.path += path
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    private var queryItems: [URLQueryItem]? {
        guard let parameters = queryParameters, !parameters.isEmpty else { return nil }
        
        var queries = [URLQueryItem]()
        for param in parameters {
            if let value = param.value {
                queries.append(URLQueryItem(name: param.key, value: String(describing: value)))
            }
        }
        
        return queries
    }
    
    private var jsonBody: Data? {
        guard [.post, .put, .patch].contains(method), let parameters = parameters else {
            return nil
        }
        var jsonBody: Data?
        do {
            jsonBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print(error)
        }
        return jsonBody
    }
    
    private func getBearerToken() -> String {
        return AppConstants.twitterBearerToken
    }
}

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

struct EmptyResponse: Decodable {}
