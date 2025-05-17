//
//  BaseViewControllerTests.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

import XCTest
@testable import TakeHome

final class MockBaseViewModel: BaseViewModelType {
    
}

final class MockBaseViewController<VM: BaseViewModelType>: BaseViewController<VM> {
    
}

final class BaseViewControllerTests: BaseTestCase {
    private var sut: MockBaseViewController<MockBaseViewModel>!
    private var mockViewModel: MockBaseViewModel!
    private var mockAlert: MockCustomAlert!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockBaseViewModel()
        mockAlert = MockCustomAlert()
        sut = MockBaseViewController(viewModel: mockViewModel, alert: mockAlert)
    }
    
    override func tearDown() {
        sut = nil
        mockAlert = nil
        mockViewModel = nil
        super.tearDown()
    }
    
    func test_handleError_unknownError() {
        // given
        let unknownError = CustomError.unknownError
        // when
        sut.handleError(unknownError, showingAlert: true)
        // then
        XCTAssertTrue(mockAlert.showAlertOneButtonIsCalled)
    }
    
    func test_handleError_noInternetError() {
        // given
        let noInternetError = CustomError.noInternet
        // when
        sut.handleError(noInternetError, showingAlert: true)
        // then
        XCTAssertTrue(mockAlert.showAlertOneButtonIsCalled)
    }
    
    func test_handleError_serializationError() {
        // given
        let error = CustomError.serialization
        // when
        sut.handleError(error, showingAlert: true)
        // then
        XCTAssertTrue(mockAlert.showAlertOneButtonIsCalled)
    }
}
