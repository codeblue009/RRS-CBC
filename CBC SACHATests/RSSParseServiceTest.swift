//
//  RSSParseServiceTest.swift
//  CBC SACHA
//
//  Created by Sacha Sukhdeo on 2018-08-26.
//  Copyright © 2018 Sacha Sukhdeo. All rights reserved.
//

import XCTest
@testable import CBC_SACHA

class RSSParseServiceTest: XCTestCase {
    
    var parser = RSSParseService()
    
    override func setUp() {
        parser = RSSParseService()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testParseType() {
        parser.parseType(byTag: "item")
        XCTAssertTrue(parser.isNewItem)
        XCTAssertNotNil(parser.currentArticle)

        parser.parseType(byTag: "title")
        XCTAssertTrue(parser.isTitle)

        parser.parseType(byTag: "author")
        XCTAssertTrue(parser.isAuthor)

        parser.parseType(byTag: "link")
        XCTAssertTrue(parser.isLink)

        parser.parseType(byTag: "pubDate")
        XCTAssertTrue(parser.isDate)
    }
    
    func testParseArticle() {
        parser.currentArticle = Article()
        parser.isTitle = true
        parser.parseArticle(characters: "myTitle")
        XCTAssertFalse(parser.isTitle)
        XCTAssertEqual((parser.currentArticle?.title)!, "myTitle")
        
        parser.isDate = true
        parser.parseArticle(characters: "today")
        XCTAssertFalse(parser.isDate)
        XCTAssertEqual((parser.currentArticle?.date)!, "today")
        
        parser.isAuthor = true
        parser.parseArticle(characters: "me")
        XCTAssertFalse(parser.isAuthor)
        XCTAssertEqual((parser.currentArticle?.author)!, "me")
        
        parser.parseArticle(characters: "\'https://www.google.com\'")
        XCTAssertEqual((parser.currentArticle?.imageUrlString)!, "https://www.google.com")
        XCTAssertEqual(parser.currentArticle?.imageUrl, URL(string: "https://www.google.com"))
        
        parser.isLink = true
        parser.parseArticle(characters: "https://www.google.com")
        XCTAssertFalse(parser.isLink)
        XCTAssertEqual((parser.currentArticle?.link)!, URL(string: "https://www.google.com"))
    }
    
    func testParseNewItemTag() {
        XCTAssertEqual(parser.parsedArticles.count, 0)
        parser.parseNewItemTag(tag: "item")
        XCTAssertEqual(parser.parsedArticles.count, 0)
        XCTAssertFalse(parser.isNewItem)

        parser.currentArticle = Article()
        parser.isNewItem = true
        parser.parseNewItemTag(tag: "item")
        XCTAssertEqual(parser.parsedArticles.count, 1)
        XCTAssertFalse(parser.isNewItem)
    }
    
}
