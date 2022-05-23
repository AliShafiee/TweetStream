//
//  TweetStreamRule.swift
//  TweetStream
//
//  Created by Ali Shafiee on 3/2/1401 AP.
//

import Foundation

struct TweetStreamRule: Codable {
    let id: String?
    let value: String?
    let tag: String?
}

struct TweetStreamRuleResponse: Codable {
    let data: [TweetStreamRule]?
}
