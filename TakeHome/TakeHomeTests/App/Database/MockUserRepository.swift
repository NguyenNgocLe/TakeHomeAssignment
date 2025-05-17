//
//  MockUserRepository.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

import Foundation
import CoreData
@testable import TakeHome

final class MockUserRepository: UserRepository {
    private var mockUsers: [UserEntity] = []
    
    override init(context: NSManagedObjectContext) {
        super.init(context: context)
    }
    
    override func saveUsers(_ users: [UserInformationModel]) throws {
        for user in users {
            let userEntity = UserEntity(context: context)
            userEntity.login = user.login
            userEntity.avatar_url = user.avatar_url
            userEntity.order = Int16(mockUsers.count)
            mockUsers.append(userEntity)
        }
    }
    
    override func fetchUsers() throws -> [UserEntity] {
        return mockUsers.sorted { $0.order < $1.order }
    }
    
    func deleteAllUsers() {
        mockUsers.removeAll()
    }
}
