//
//  UITableViewExtTests.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

import UIKit
@testable import TakeHome
import XCTest

class MockMyCell: UITableViewCell {}

class MockMyHeaderFooter: UITableViewHeaderFooterView {}

class UITableViewExtensionsTests: XCTestCase {
    var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        tableView = UITableView(frame: .zero)
    }
    
    override func tearDown() {
        tableView = nil
        super.tearDown()
    }
    
    func testRegisterAndDequeueCellWithClassName() {
        // given
        tableView.registerClassWithClassName(cellType: MockMyCell.self)
        // when
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.dataSource = StubDataSource()
        //then
        let cell = tableView.dequeueReusableCellWithClassName(with: MockMyCell.self, for: indexPath)
        XCTAssertTrue(cell is MockMyCell)
    }
    
    func testDequeueReusableCell() {
        _ = tableView.dequeueReusableCell(withIdentifier: "MyCell") as? MockMyCell
    }
    
    func testRegisterHeaderFooterWithClassName() {
        // when
        tableView.registerClassWithClassName(reusableViewType: MockMyHeaderFooter.self)
        
        // then
        let headerFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: MockMyHeaderFooter.className)
        XCTAssertTrue(headerFooter is MockMyHeaderFooter)
    }
}

private class StubDataSource: NSObject, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
