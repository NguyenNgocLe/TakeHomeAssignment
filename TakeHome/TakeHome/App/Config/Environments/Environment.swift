//
//  Environment.swift
//  TakeHome
//
//  Created by Le on 16/5/25.
//

import Foundation


enum Plist: String {
    case environmentConstants
    case baseUrl = "BASE_URL"
    case logEnabled = "LOG_ENABLED"
}

// Define environment
enum Environment {
    static func configuration(key: Plist) -> String {
        if let infoDict = Bundle.main.infoDictionary,
           let constantsDict = infoDict[Plist.environmentConstants.rawValue] as? [String: Any],
           let value = constantsDict[key.rawValue] as? String {
            return value
        } else {
            fatalError("Unable to access \(key.rawValue) in Info.plist")
        }
    }
    
    static func configuration(key: Plist) -> Int {
        return Int(configuration(key: key))!
    }

    static func configuration(key: Plist) -> Bool {
        return Bool(configuration(key: key))!
    }
}
