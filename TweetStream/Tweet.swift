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

extension Tweet: IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: Identity {
        return text
    }
}

struct SectionOfTweet {
    var header: String
    var items: [Item]
}

extension SectionOfTweet: AnimatableSectionModelType {
   
    typealias Item = Tweet
    typealias Identity = String

    init(original: SectionOfTweet, items: [Item]) {
        self = original
        self.items = items
    }
    
    var identity: String {
        return header
    }
}
