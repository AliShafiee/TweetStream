//
//  Tweet.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import Foundation

struct Tweet: Codable {
    
    let id: String
    let text: String
    let users: [TweetUser]

    enum RootKeys: String, CodingKey {
        case data
        case includes
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        let dataContainer = try rootContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        let includesContainer = try rootContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .includes)
        id = try dataContainer.decode(String.self, forKey: .id)
        text = try dataContainer.decode(String.self, forKey: .text)
        users = try includesContainer.decode([TweetUser].self, forKey: .users)
    }
}

struct TweetUser: Codable {
    
    let id: String
    let name: String
    let username: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        username = try container.decode(String.self, forKey: .username)
    }
}
