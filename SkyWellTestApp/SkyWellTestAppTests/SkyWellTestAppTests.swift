//
//  SkyWellTestAppTests.swift
//  SkyWellTestAppTests
//
//  Created by Yurii on 2/19/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

import XCTest
@testable import SkyWellTestApp

class SkyWellTestAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
//Post
    //delete empty post
    func testSetPostWithEmptyDictionary() {
        let count:UInt = Post.MR_countOfEntities()
        let post:Post = Post.MR_createEntity()!
        let count1:UInt = Post.MR_countOfEntities()
        XCTAssertTrue(count != count1)
        post.setData(NSDictionary() as [NSObject : AnyObject])
        let count2:UInt = Post.MR_countOfEntities()
        XCTAssertTrue(count == count2)
    }

}
