//  RSSFeedServiceTest.swift
//  CBC SACHA
//
//  Created by Sacha Sukhdeo on 2018-08-24.
//  Copyright © 2018 Sacha Sukhdeo. All rights reserved.

import XCTest
@testable import CBC_SACHA


class RSSFeedServiceTest: XCTestCase {
    
    
    var RSSFeed: RSSFeedService?
    
    override func setUp() {
        super.setUp()
        RSSFeed = RSSFeedService()
    }
    
    override func tearDown() {
        RSSFeed = nil
        super.tearDown()
    }
    
    func testGetTopStories() {
        XCTAssertTrue((RSSFeed?.getTopStories().count)! > 0)
    }
    
}
