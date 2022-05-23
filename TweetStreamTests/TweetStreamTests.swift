//
//  TweetStreamTests.swift
//  TweetStreamTests
//
//  Created by Ali Shafiee on 2/30/1401 AP.
//

import XCTest
@testable import TweetStream

class TweetStreamTests: XCTestCase {

    var streamRequest: TwitterApiService!
    var retrieveRequest: TwitterApiService!
    var addRuleRequest: TwitterApiService!
    var tweetViewModel: TweetViewModel!

    override func setUpWithError() throws {
        streamRequest = TwitterApiService.stream
        retrieveRequest = TwitterApiService.retrieveRules
        addRuleRequest = TwitterApiService.addRules(rules: [])
        tweetViewModel = TweetViewModel(tweet: Tweet(id: "1232424", text: "Test Tweet", users: [TweetUser(id: "78123783", name: "Ali Shafiee", username: "Alishafiee")]))
    }

    override func tearDownWithError() throws {
        streamRequest = nil
        retrieveRequest = nil
        addRuleRequest = nil
        tweetViewModel = nil
    }
    
    func testStreamTweetsRequest() {
        XCTAssertEqual(streamRequest.baseUrl, AppConstants.baseUrl)
        XCTAssertEqual(streamRequest.requestType, .stream(throttleDuration: 3))
        XCTAssertNotEqual(streamRequest.requestType, .stream(throttleDuration: 1))
        XCTAssertEqual(streamRequest.method, .get)
        XCTAssertEqual(streamRequest.path, "2/tweets/search/stream")
        XCTAssertEqual(streamRequest.queryParameters?.count, Optional(2))
        XCTAssertNil(streamRequest.parameters)
    }
    
    func testRetrieveRulesRequest() {
        XCTAssertEqual(retrieveRequest.baseUrl, AppConstants.baseUrl)
        XCTAssertEqual(retrieveRequest.requestType, .data)
        XCTAssertNotEqual(retrieveRequest.requestType, .stream(throttleDuration: 1))
        XCTAssertNotEqual(retrieveRequest.method, .post)
        XCTAssertEqual(retrieveRequest.path, "2/tweets/search/stream/rules")
        XCTAssertNil(retrieveRequest.parameters)
    }
    
    func testAddRulesRequest() {
        XCTAssertEqual(addRuleRequest.baseUrl, AppConstants.baseUrl)
        XCTAssertEqual(addRuleRequest.requestType, .data)
        XCTAssertEqual(addRuleRequest.method, .post)
        XCTAssertEqual(addRuleRequest.path, "2/tweets/search/stream/rules")
        XCTAssertNotNil(addRuleRequest.parameters)
        XCTAssertNotEqual(addRuleRequest.queryParameters?.count, Optional(1))
    }
    
    func testTweetViewModel() {
        XCTAssertNotEqual(tweetViewModel.username, "Alishafiee")
        XCTAssertEqual(tweetViewModel.username, "@Alishafiee")
        XCTAssertNotNil(tweetViewModel.name)
    }

}
