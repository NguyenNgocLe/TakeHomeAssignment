//
//  FollowModel.swift
//  TakeHome
//
//  Created by Le on 17/5/25.
//

import Foundation

struct FollowModel: Codable {
    let login: String
    
    init(login: String = "") {
        self.login = login
    }
}

struct InformationUserModel: Codable {
    let location: String?
    let blog: String?
}

