//
//  AFErrorExtTests.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

import XCTest
@testable import TakeHome
import Mocker
import XCTest
import Alamofire

final class AFErrorExtTests: XCTestCase {
    private func createAFError(statusCode: Int, data: Data,
                               requestError: URLError?) -> AFError {
        let url = "https://test.com/"
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let session = Session(configuration: configuration)
        let mock = Mock(url: URL(string: url)!, contentType: .json,
                        statusCode: statusCode, data: [.get: data],
                        requestError: requestError)
        mock.register()
        let promise = expectation(description: "")
        var result: AFError!
        return result
    }
}
