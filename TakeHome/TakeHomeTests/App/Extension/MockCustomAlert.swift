//
//  MockCustomAlert.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

import Foundation
@testable import TakeHome
import XCTest

final class MockCustomAlert: CustomAlertType {
    var showErrorBottomSheetIsCalled = false
    var showWarningBottomSheetIsCalled = false
    var showSuccessBottomSheetIsCalled = false
    var showAlertErrorNetworkIsCalled = false
    var showATTPermisionAlert = false
    var showAlertOneButtonIsCalled = false
    var showAlertTwoButton = false
    var shotFilterBottomSheetIsCalled = false
    var viewController: UIViewController?
    var title, message, buttonTitle, leftButtonTitle, rightButtonTitle: String?
    var handler, leftButtonHandler, rightButtonHandler, shareHandler, reportHandler: (() -> Void)?
    var leftButtonColor: ColorButtonType?
    var rightButtonColor: ColorButtonType?

    func showErrorBottomSheet(_ viewController: UIViewController, message: String,
                              handler: (() -> Void)?) {
        showErrorBottomSheetIsCalled = true
        self.viewController = viewController
        self.message = message
        self.handler = handler
    }

    func showWarningBottomSheet(_ viewController: UIViewController, message: String,
                                handler: (() -> Void)?) {
        showWarningBottomSheetIsCalled = true
        self.viewController = viewController
        self.message = message
        self.handler = handler
    }

    func showSuccessBottomSheet(_ viewController: UIViewController, title: String,
                                message: String, handler: (() -> Void)?) {
        showSuccessBottomSheetIsCalled = true
        self.viewController = viewController
        self.title = title
        self.message = message
        self.handler = handler
    }

    func showAlertErrorNetwork(_ viewController: UIViewController, handler: (() -> Void)?) {
        showAlertErrorNetworkIsCalled = true
        self.viewController = viewController
        self.handler = handler
    }

    func showATTPermisionAlert(_ viewController: UIViewController, leftButtonHandler: (() -> Void)?,
                               rightButtonHandler: (() -> Void)?) {
        showATTPermisionAlert = true
        self.viewController = viewController
        self.leftButtonHandler = leftButtonHandler
        self.rightButtonHandler = rightButtonHandler
    }

    func showAlertOneButton(_ viewController: UIViewController,
                            title: String?, message: String?,
                            buttonTitle: String?, handler: (() -> Void)?) {
        showAlertOneButtonIsCalled = true
        self.viewController = viewController
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.handler = handler
    }

    func showAlertTwoButton(_ viewController: UIViewController,
                            title: String?, message: String?,
                            leftButtonTitle: String?, rightButtonTitle: String?,
                            leftButtonHandler: (() -> Void)?, rightButtonHandler: (() -> Void)?,
                            leftButtonColor: ColorButtonType?, rightButtonColor: ColorButtonType?) {
        showAlertTwoButton = true
        self.viewController = viewController
        self.title = title
        self.message = message
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.leftButtonHandler = leftButtonHandler
        self.rightButtonHandler = rightButtonHandler
        self.leftButtonColor = leftButtonColor
        self.rightButtonColor = rightButtonColor
    }
}
