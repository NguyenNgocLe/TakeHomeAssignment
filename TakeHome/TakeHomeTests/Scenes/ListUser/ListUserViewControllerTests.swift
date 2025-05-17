//
//  ListUserViewControllerTests.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

import XCTest
import Mocker
@testable import TakeHome

final class MockListUserViewController<VM: ListUserViewModelType>: ListUserViewController<VM> {
    
}

final class ListUserViewControllerTest: XCTestCase {
    private var sut: MockListUserViewController<MockListUserViewModel>!
    private var mockVM: MockListUserViewModel!
    private var mockHud: MockCustomHud!
    private var mockAlert: MockCustomAlert!
    
    override func setUp() {
        super.setUp()
        let users = [
            UserInformationModel(login: "user1", avatar_url: "url1"),
            UserInformationModel(login: "user2", avatar_url: "url2")
        ]
        mockVM = MockListUserViewModel(users: users)
        mockHud = MockCustomHud()
        mockAlert = MockCustomAlert()
        sut = MockListUserViewController(viewModel: mockVM, hud: mockHud,
                                         alert: mockAlert)
    }
    
    override func tearDown() {
        sut = nil
        mockVM = nil
        mockHud = nil
        mockAlert = nil
        super.tearDown()
    }
    
    func testLoadNibFile_whenLoadView_ShouldNotBeNil() {
        // then
        XCTAssertNotNil(sut, "ViewController should not be nil")
        XCTAssertNotNil(sut.view, "View should not be nil")
    }
    
    func testLoadTableViewAndTitleLabel_whenLoadView_ShouldConnectAndNotNil() {
        //when
        sut.loadViewIfNeeded()

        //then
        XCTAssertNotNil(sut.title, "titleLabel should not be nil")
        XCTAssertNotNil(sut.tableView, "tableView should not be nil")
    }
    
    func testSetupTableView_WhenLoadView_ShouldNotBeNilAndDelegateToViewController() {
        // when
        sut.loadViewIfNeeded()
        
        //then
        XCTAssertNotNil(sut.tableView.delegate, "TableView delegate should be set.")
        XCTAssertNotNil(sut.tableView.dataSource, "TableView dataSource should be set.")
        XCTAssertTrue(sut.tableView.delegate === sut, "TableView delegate should be the view controller.")
        XCTAssertTrue(sut.tableView.dataSource === sut, "TableView dataSource should be the view controller.")
        XCTAssertNotNil(sut.tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier), "TableView should have registered the UserTableViewCell.")
    }
}
