//
//  CustomSessionTests.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

import XCTest
import Mocker
import Alamofire
import Foundation
@testable import TakeHome

struct MockKnownError: Codable {
    let message: String
    let errorCode: String

    private enum CodingKeys: String, CodingKey {
        case message
        case errorCode = "error_code"
    }
}

final class CustomSessionTests: BaseTestCase {
    var sut: CustomSession!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        sut = CustomSession(configuration: configuration)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    /// Given: baseUrl contains the character "/" and end point no contains the character "/"
    /// When: Call handleUrlPath
    /// Then: Valid url
    func test_handleUrlPath_bothNoSlash_isSuccess() {
        // given
        let baseUrl = "https://testapi/api/v1/"
        let endPoint = "?test/abc"
        // when
        let result = sut.handleUrlPath(endPoint: endPoint, baseUrl: baseUrl)
        // then
        XCTAssertEqual("https://testapi/api/v1?test/abc", result)
    }
    
    /// Given: baseUrl no contains the character "/" and end point contains the character "/"
    /// When: Call handleUrlPath
    /// Then: Valid url
    func test_handleUrlPath_baseUrlNoSlash_endPointSlash_isSuccess() {
        // given
        let baseUrl = "https://testapi/api/v1"
        let endPoint = "/test/abc"
        // when
        let result = sut.handleUrlPath(endPoint: endPoint, baseUrl: baseUrl)
        // then
        XCTAssertEqual("https://testapi/api/v1/test/abc", result)
    }
    
    /// Given: API returns success response
    /// When: call request
    /// Then: reponse JSON Data success
    func test_request_isSuccess() {
        // given
        let givenUserProfile = getDummyFreeUserInformation()
        let data = try! JSONEncoder().encode(givenUserProfile)
        let promise = expectation(description: "API mockup invoked")
        let mock = Mock(url: URL(string: "\(baseApiUrl)/user/abc")!,
                        contentType: .json, statusCode: 200,
                        data: [.get: data])
        mock.register()
        // when
        var userProfile: UserInformationModel?
        sut.request(endPoint: "/user/abc",
                    expectedDataType: UserInformationModel.self,
                    method: .get, parameters: nil,
                    encoding: URLEncoding.default) { result in
            userProfile = try? result.get()
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1.0)
        // then
        XCTAssertEqual(userProfile, givenUserProfile)
    }
    
    /// Given: API returns failed response
    /// When: call request
    /// Then: reponse JSON failed
    func test_request_isFailed() {
        // given
        let promise = expectation(description: "API mockup invoked")
        let mock = Mock(url: URL(string: "\(baseApiUrl)/user/xyz/")!,
                        contentType: .json, statusCode: 400,
                        data: [.get: Data()])
        mock.register()
        // when
        var errorResult: CustomError?
        sut.request(endPoint: "/user/xyz/",
                    expectedDataType: UserInformationModel.self,
                    method: .get, parameters: nil,
                    encoding: URLEncoding.default) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                errorResult = error
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1.0)
        // then
        XCTAssertEqual(CustomError.unknownError, errorResult)
    }
    
    /// Given: API returns 200 status code, but the response is not valid
    /// When: Call request
    /// Then: Receive serialization error
    func test_request_serializerFailure() {
        // given
        var errorResult: CustomError?
        let givenUserProfile = getDummyFreeUserInformation()
        let data = try! JSONEncoder().encode(givenUserProfile)
        let promise = expectation(description: "API mockup invoked")
        let mock = Mock(url: URL(string: "\(baseApiUrl)/user/test/")!,
                        contentType: .json, statusCode: 200,
                        data: [.get: data])
        mock.register()
        // when
        sut.request(endPoint: "/user/test/",
                    expectedDataType: Data.self,
                    method: .get, parameters: nil,
                    encoding: URLEncoding.default) { result in
            switch result {
            case .success:
                break
            case .failure(let err):
                errorResult = err
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1.0)
        // then
        XCTAssertEqual(CustomError.serialization, errorResult)
    }
    
    /// Given: Simulate know error response
    /// When: Call request
    /// Then: Receive failure response
    func test_responseKnowError() {
        // given
        let givenJSON = MockKnownError(message: "test", errorCode: "information_test_invalid")
        let data = try! JSONEncoder().encode(givenJSON)
        let promise = expectation(description: "API mockup invoked")
        let mock = Mock(url: URL(string: "\(baseApiUrl)/user/test/")!,
                        contentType: .json, statusCode: 400,
                        data: [.post: data])
        mock.register()
        // when
        var error: CustomError?
        sut.request(endPoint: "/user/test/",
                    expectedDataType: MockKnownError.self,
                    method: .post, parameters: nil,
                    encoding: URLEncoding.default) { result in
            switch result {
            case .success:
                break
            case .failure(let err):
                error = err
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1.0)
        // then
        XCTAssertEqual(CustomError.knownError(errorCode: "information_test_invalid"), error)
    }
}
