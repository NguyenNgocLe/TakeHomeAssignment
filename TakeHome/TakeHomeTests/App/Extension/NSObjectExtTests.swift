//
//  NSObjectExtTests.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

import XCTest
@testable import TakeHome

class ClassNameProtocolTests: XCTestCase {
    class MyObject: NSObject {}
    class MyCustomClass: ClassNameProtocol {}
    
    func testNSObjectClassName() {
        // then
        XCTAssertEqual(MyObject.className, "MyObject")
    }
    
    func testCustomClassClassName() {
        // then
        XCTAssertEqual(MyCustomClass.className, "MyCustomClass")
        XCTAssertEqual(MyCustomClass().className, "MyCustomClass")
    }
    
    func testNSObjectBuiltIn() {
        // then
        XCTAssertEqual(NSString.className, "NSString")
    }
    
    func testNSStringClassName_Instance() {
        // given
        let validClassNames: Set<String> = [
            "NSString",
            "__NSCFConstantString",
            "NSTaggedPointerString"
        ]
        // then
        XCTAssertTrue(validClassNames.contains(NSString().className))
        XCTAssertTrue(validClassNames.contains(("hello" as NSString).className))
    }
}
