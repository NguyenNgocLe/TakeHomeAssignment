//
//  DetailsUserViewControllerTests.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

import XCTest
import Mocker
@testable import TakeHome

final class DetailsUserViewControllerTest: BaseTestCase {
    private var mockViewModel: MockDetailsUserViewModel!
    private var mockHud: MockCustomHud!
    private var mockAlert: MockCustomAlert!
    private var sut: DetailsUserViewController<MockDetailsUserViewModel>!
    private var mockUserDetails = UserDetailsModel(imageViewURL: "https://test.jpg", name: "test")
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockDetailsUserViewModel(user: mockUserDetails)
        mockHud = MockCustomHud()
        mockAlert = MockCustomAlert()
        sut = DetailsUserViewController(viewModel: mockViewModel, hud: mockHud)
        _ = sut.view
    }
    
    override func tearDown() {
        sut = nil
        mockViewModel = nil
        mockHud = nil
        mockAlert = nil
        super.tearDown()
    }
    
    func testGetInformationFailed_ShouldHideHudAndShowErrorAlert() {
        // when
        sut.getInformationFailed()
        mockViewModel.getDataFailedHandler?(.noInternet)
        // then
        XCTAssertTrue(mockHud.hideMockHudIsCalled)
    }
}
