//
//  MockDataManger.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

import Foundation
import CoreData
import XCTest

@testable import TakeHome

class MockCoreDataManager: CoreDataManager {
    var isDeleteAllUsersCalled = false

    override func deleteAllUsers() {
        isDeleteAllUsersCalled = true
    }
}

final class MockDataManagerTests: BaseTestCase {

    func testDeleteAllUsers_Called() {
        // given
        let mockManager = MockCoreDataManager()
        
        // when
        mockManager.deleteAllUsers()
        
        // then
        XCTAssertTrue(mockManager.isDeleteAllUsersCalled)
    }
}
