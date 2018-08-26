//
//  MasterViewControllerTest.swift
//  CBC SACHA
//
//  Created by Sacha Sukhdeo on 2018-08-19.
//  Copyright © 2018 Sacha Sukhdeo. All rights reserved.
//

import XCTest
@testable import CBC_SACHA

class MasterViewControllerTest: XCTestCase {
    
    var masterVC: MasterViewController!
    
    override func setUp() {
        super.setUp()
        masterVC = MasterViewController()
        masterVC.articles = [Article.init()]
    }
    
    override func tearDown() {
        super.tearDown()
        masterVC = nil
    }
    
    func testRefresh() {
        masterVC.refresh(self)
        XCTAssertTrue({(masterVC.articles?.count)! > 1}())
    }
    
}
