//
//  MockCustomHud.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

@testable import TakeHome
import XCTest

final class MockCustomHud: CustomHudType {
    var showMockHudIsCalled = false
    var hideMockHudIsCalled = false

    func showHud(message _: String?) {
        showMockHudIsCalled = true
    }

    func hideHud() {
        hideMockHudIsCalled = true
    }
}
