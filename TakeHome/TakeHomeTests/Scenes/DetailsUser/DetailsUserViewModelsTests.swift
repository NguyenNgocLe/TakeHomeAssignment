//
//  DetailsViewModelsTests.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

import XCTest
import Mocker
@testable import TakeHome

final class MockDetailsUserViewModel: DetailsUserViewModelType {
    var getDataFailedHandler: ((CustomError) -> Void)?
    var getAllInfoSuccess: ((DetailsUserModel) -> Void)?
    var isGetUserCalled = false
    var userDetails: UserDetailsModel
    
    init(user: UserDetailsModel) {
        self.userDetails = user
    }
    
    func getUserFollowingAndFollower() async {
        isGetUserCalled = true
    }
    func getUserDetailsModel() -> UserDetailsModel { userDetails }
}

final class DetailsUserViewModelsTests: BaseTestCase {
    private var mockSession: MockSession!
    private var sut: DetailsUserViewModel!
    private var mockUserDetails: UserDetailsModel!
    private var detailsUserModel: DetailsUserModel!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        mockUserDetails = UserDetailsModel(imageViewURL: "abc", name: "abc")
        mockSession = MockSession(configuration: configuration)
        sut = DetailsUserViewModel(session: mockSession, userDetailsModel: mockUserDetails)
    }
    
    override func tearDown() {
        sut = nil
        mockSession = nil
        mockUserDetails = nil
        detailsUserModel = nil
        super.tearDown()
    }
    
    func test_getUserFollowingAndFollower_success() async {
        // given
        let followers = [FollowModel(), FollowModel()]
        let followings = [FollowModel()]
        let infoModel = InformationUserModel(location: "Saigon", blog: "123.me")
        mockSession.overrideResponses = [
            "/abc/followers": .success(followers),
            "/abc/following": .success(followings),
            "/abc": .success(infoModel)
        ]

        let expectation = expectation(description: "getAllInfoSuccess called")
        
        sut.getAllInfoSuccess = { details in
            // then
            XCTAssertEqual(details.numberFollower, followers.count)
            XCTAssertEqual(details.numberFollowing, followings.count)
            XCTAssertEqual(details.location, "Saigon")
            XCTAssertEqual(details.blog, "123.me")
            expectation.fulfill()
        }
        
        // when
        await sut.getUserFollowingAndFollower()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func test_getUserFollowingAndFollower_followerApiFailed() async {
        // given
        mockSession.overrideResponses = [
            "/testuser/followers": .failure(.unknownError),
            "/testuser/following": .success([FollowModel()]),
            "/testuser": .success(InformationUserModel(location: "abc", blog: "blog"))
        ]
        
        let expectation = expectation(description: "getDataFailedHandler called")
        var fulfilled = false
        
        sut.getAllInfoSuccess = { _ in
            XCTFail("getAllInfoSuccess should NOT be called")
        }
        sut.getDataFailedHandler = { error in
            XCTAssertEqual(error, .unknownError)
            if !fulfilled {
                expectation.fulfill()
                fulfilled = true
            }
        }
        
        // when
        await sut.getUserFollowingAndFollower()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func test_getUserFollowingAndFollower_followingApiFailed() async {
        // given
        mockSession.overrideResponses = [
            "/testuser/followers": .success([FollowModel()]),
            "/testuser/following": .failure(.unknownError),
            "/testuser": .success(InformationUserModel(location: "abc", blog: nil))
        ]
        
        let expectation = expectation(description: "getDataFailedHandler called")
        var fulfilled = false
        sut.getAllInfoSuccess = { _ in
            XCTFail("getAllInfoSuccess should NOT be called")
        }
        sut.getDataFailedHandler = { error in
            // then
            XCTAssertEqual(error, .unknownError)
            if !fulfilled {
                expectation.fulfill()
                fulfilled = true
            }
        }
        // when
        await sut.getUserFollowingAndFollower()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func test_getUserFollowingAndFollower_infoApiFailed() async {
        // given
        mockSession.overrideResponses = [
            "/testuser/followers": .success([FollowModel()]),
            "/testuser/following": .success([FollowModel(), FollowModel()]),
            "/testuser": .failure(.unknownError)
        ]
        
        let expectation = expectation(description: "getDataFailedHandler called")
        
        sut.getAllInfoSuccess = { _ in
            // then
            XCTFail("getAllInfoSuccess should NOT be called")
        }
        var fulfilled = false
        sut.getDataFailedHandler = { error in
            // then
            XCTAssertEqual(error, .unknownError)
            if !fulfilled {
                expectation.fulfill()
                fulfilled = true
            }
        }
        // when
        await sut.getUserFollowingAndFollower()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func test_getUserFollowingAndFollower_infoNilLocationBlog() async {
        // given
        mockSession.overrideResponses = [
            "/abc/followers": .success([]),
            "/abc/following": .success([]),
            "/abc": .success(InformationUserModel(location: nil, blog: nil))
        ]
        
        let expectation = expectation(description: "getAllInfoSuccess called")
        var fulFilled = false
        sut.getAllInfoSuccess = { details in
            // then
            XCTAssertEqual(details.location, "VietNam")
            XCTAssertEqual(details.blog, "")
            if !fulFilled {
                expectation.fulfill()
                fulFilled = true
            }
        }
        sut.getDataFailedHandler = { _ in
            XCTFail("Should not call fail when info fields nil")
        }
        // when
        await sut.getUserFollowingAndFollower()
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
