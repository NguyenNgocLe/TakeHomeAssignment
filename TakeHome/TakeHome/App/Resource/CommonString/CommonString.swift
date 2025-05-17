//
//  CommonString.swift
//  TakeHome
//
//  Created by Le on 17/5/25.
//

import Foundation

struct CommonString {
    static let error = "Error".localized
    static let cancel = "Cancel".localized
    static let no = "No".localized
    static let yes = "Yes".localized
    static let success = "Success".localized
    static let retry = "Retry".localized
    static let ok = "OK".localized
    static let githubUser = "GitHub user"
    static let detailsUser = "Details user"
    static let follower = "Follower"
    static let following = "Following"
    static let blog = "Blog"
    static let profileUrl = "https://www.linkedin.com/"
    
    private static let localizedErrorMessages: [String: String] = [
        "unauthorized": "The User Unauthorized.".localized,
    ]
    
    static func getErrorMessage(for errorCode: String) -> String? {
        return CommonString.localizedErrorMessages[errorCode]
    }
}
