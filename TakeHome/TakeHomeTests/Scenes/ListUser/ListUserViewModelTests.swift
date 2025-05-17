//
//  ListUserViewModelTests.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

import XCTest
@testable import TakeHome
import Mocker
import Alamofire
import CoreData

final class MockListUserViewModel: ListUserViewModelType {
    var getListUsersSuccessHandler: (() -> Void)?
    var getListUsersFailureHandler: ((CustomError) -> Void)?
    
    private var users: [UserInformationModel] = []
    var fetchUsersCalled = false
    
    init(users: [UserInformationModel] = []) {
        self.users = users
    }
    
    func fetchUsers() {
        fetchUsersCalled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            self?.getListUsersSuccessHandler?()
        }
    }
    func getNumberOfRows() -> Int { users.count }
    func getUser(at index: Int) -> UserInformationModel? {
        guard index < users.count else { return nil }
        return users[index]
    }
}

final class ListUserViewModelTests: BaseTestCase {
    private var mockRepository: MockUserRepository!
    private var mockSession: MockSession!
    private var sut: ListUserViewModel!
    private var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        mockSession = MockSession(configuration: configuration)
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mockRepository = MockUserRepository(context: context)
        sut = ListUserViewModel(userRepository: mockRepository, session: mockSession)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        mockSession = nil
        context = nil
        super.tearDown()
    }
    
    func test_fetchUsers_shouldCallFailureHandler_whenLocalLoadFails() {
        // given
        mockRepository.deleteAllUsers()
        let originalFetchUsers = mockRepository.fetchUsers
        var handlerCalledError: CustomError?
        var listUserFailureIsCalled = false
        let expectationFail = expectation(description: "Failure handler called")
        sut.getListUsersFailureHandler = { error in
            handlerCalledError = error
            listUserFailureIsCalled = true
            expectationFail.fulfill()
        }
        
        // when
        sut.fetchUsers()
        
        // then
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(handlerCalledError, .unknownError)
        XCTAssertTrue(listUserFailureIsCalled)
    }
    
    func test_fetchUsers_shouldReturnLocalData_ifCoreDataNotEmpty() {
        // given
        let users = [
            getDummyFreeUserInformation(login: "user1"),
            getDummyFreeUserInformation(login: "user2"),
        ]
        try? mockRepository.saveUsers(users)
        let expectationSuccess = expectation(description: "Success Handler Called")
        var completionCalled = false
        
        sut.getListUsersSuccessHandler = {
            completionCalled = true
            expectationSuccess.fulfill()
        }
        
        // when
        sut.fetchUsers()
        
        // then
        waitForExpectations(timeout: 1.0)
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(sut.getNumberOfRows(), 2)
        XCTAssertEqual(sut.getUser(at: 0)?.login, "user1")
        XCTAssertEqual(sut.getUser(at: 1)?.login, "user2")
    }
    
    func test_getUser_returnsNilIfIndexOutOfBounds() {
        // given
        let users = [
            getDummyFreeUserInformation(login: "user1")
        ]
        try? mockRepository.saveUsers(users)
        sut.fetchUsers()
        // when
        let user = sut.getUser(at: 100)
        // then
        XCTAssertNil(user)
    }
    
    func test_getUser_returnsNil_onNegativeIndex() {
        // given
        let users = [
            getDummyFreeUserInformation(login: "user1")
        ]
        try? mockRepository.saveUsers(users)
        sut.fetchUsers()
        // when
        let user = sut.getUser(at: -1)
        // then
        XCTAssertNil(user)
    }
}
