//
//  BaseTestCase.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

import XCTest
@testable import TakeHome

class BaseTestCase: XCTestCase {
    lazy var baseApiUrl: String = Environment.configuration(key: .baseUrl)
    
    func getDummyFreeUserInformation() -> UserInformationModel {
        return UserInformationModel(login: "abc", avatar_url: "https://picsum.photos/seed/picsum/200/300")
    }
    
    func getDummyFreeUserInformation(login: String) -> UserInformationModel {
        return UserInformationModel(login: login, avatar_url: "https://picsum.photos/seed/picsum/200/300")
    }
    
    func getDummyFreeUserInformation(login: String, avatarUrl: String) -> UserInformationModel {
        return UserInformationModel(login: login, avatar_url: avatarUrl)
    }
}
