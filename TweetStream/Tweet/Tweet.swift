//
//  Tweet.swift
//  TweetStream
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import Foundation
import RxDataSources

struct Tweet: Codable, Identifiable {
    
    let id: String
    let text: String
   
    enum RootKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        let container = try rootContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        id = try container.decode(String.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
    }
    
    init(id: String, text: String) {
        self.id = id
        self.text = text
    }
}
