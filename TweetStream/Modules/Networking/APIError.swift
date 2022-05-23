//
//  APIError.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import Foundation
import Alamofire

enum APIError: Error {
    /// No data received from the server.
    case noData
    
    /// The server response was invalid (unexpected format).
    case invalidResponse
    
    /// The request was rejected: 400-499
    case badRequest(msg: String, status: Int)
    
    /// Encoutered a server error.
    case serverError(msg: String, status: Int)
    
    /// There was an error parsing the data.
    case decodingError
    
    /// Error on create url request
    case urlRequestError
    
    /// Error on create file url
    case fileUrlError
    
    /// timeout error
    case timeout
    
    /// no internet connection error
    case noInternet
    
    /// connection lost error
    case connectionLost
    
    /// server error
    case internalServerError
    
    /// token error
    case tokenError
    
    /// Unknown error.
    case unknown
    
}

extension Error {
    
    func APIError() -> APIError {
        let code = (self as NSError).code
        switch code {
        case NSURLErrorTimedOut:
            return .timeout
            
        case NSURLErrorNotConnectedToInternet, NSURLErrorCannotConnectToHost, NSURLErrorDataNotAllowed:
            return .noInternet

        case NSURLErrorNetworkConnectionLost:
            return .connectionLost

        default:
            return .internalServerError
        }
    }
}

extension AFError {
    
    func APIError() -> APIError {
        switch self.responseCode ?? 200 {
        case 200...299:
            return .unknown
        case 401:
            return .tokenError
        case 400...499:
            return .badRequest(msg: self.errorDescription ?? "bad request!!!", status: self.responseCode ?? 200)
        case 500...599:
            return .serverError(msg: self.errorDescription ?? "server error!!!", status: self.responseCode ?? 200)
        default:
            return .unknown
        }
    }
}
