//
//  CustomLogs.swift
//  TakeHome
//
//  Created by Le on 17/5/25.
//

import Foundation

final class CustomLogs {
    private static let logEnabled: Bool = Environment.configuration(key: .logEnabled)

    static func log(_ message: Any) {
        if logEnabled {
            debugPrint(message)
        }
    }
}
