//
//  MockNavigationController.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

import UIKit

final class MockNavigationController: UINavigationController {
    var popViewControllerIsCalled = false
    var pushViewControllerIsCalled: [Bool] = []
    var viewController: UIViewController?
    
    override func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerIsCalled = true
        return super.popViewController(animated: animated)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerIsCalled.append(true)
        self.viewController = viewController
        super.pushViewController(viewController, animated: false)
    }
}
