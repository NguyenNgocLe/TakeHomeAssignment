//
//  CustomHud.swift
//  TakeHome
//
//  Created by Le on 17/5/25.
//

import Foundation
import SVProgressHUD

/// Define method show & hide hud loading
protocol CustomHudType {
    func showHud(message _: String?)
    func hideHud()
}

/// Details method show & hide hud loading
final class CustomHud: CustomHudType {
    static let shared = CustomHud()

    private init() {}

    func showHud(message _: String?) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    }

    func hideHud() {
        SVProgressHUD.dismiss()
    }
}

