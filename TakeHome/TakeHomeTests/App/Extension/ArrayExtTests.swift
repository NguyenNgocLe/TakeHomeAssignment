//
//  ArrayExtTests.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

@testable import TakeHome
import XCTest

class ArraySafeSubscriptTests: XCTestCase {
    
    func testSafeSubscriptWithinBounds() {
        // given
        let array = [10, 20, 30, 40]
        // then
        XCTAssertEqual(array[safe: 0], 10)
        XCTAssertEqual(array[safe: 2], 30)
        XCTAssertEqual(array[safe: 3], 40)
    }
    
    func testSafeSubscriptOutOfBounds() {
        // given
        let array = [10, 20, 30, 40]
        // then
        XCTAssertNil(array[safe: -1])
        XCTAssertNil(array[safe: 4])
        XCTAssertNil(array[safe: 100])
    }
    
    func testSafeSubscriptOnEmptyArray() {
        // given
        let array: [Int] = []
        // then
        XCTAssertNil(array[safe: 0])
        XCTAssertNil(array[safe: -1])
    }
    
    func testSafeSubscriptWithDifferentElementTypes() {
        // given
        let stringArray = ["a", "b", "c"]
        // then
        XCTAssertEqual(stringArray[safe: 1], "b")
        XCTAssertNil(stringArray[safe: 5])
    }
    
    
    func testSafeSubscriptNegativeIndexReturnsNil() {
        // given
        let array = [1, 2, 3]
        // then
        XCTAssertNil(array[safe: -1])
        XCTAssertNil(array[safe: -99])
    }
    
    func testSafeSubscriptIndexExceedingCountReturnsNil() {
        // given
        let array = [1, 2, 3]
        // then
        XCTAssertNil(array[safe: 3])
        XCTAssertNil(array[safe: 10])
    }
    
    func testSafeSubscriptEmptyArrayAlwaysNil() {
        // given
        let array: [String] = []
        // then
        XCTAssertNil(array[safe: 0])
        XCTAssertNil(array[safe: 1])
        XCTAssertNil(array[safe: -1])
    }
    
    func testSafeSubscriptWithStrings() {
        // given
        let fruits = ["apple", "banana"]
        // then
        XCTAssertEqual(fruits[safe: 1], "banana")
        XCTAssertNil(fruits[safe: 2])
    }
}
