//
//  CoreDataRepository.swift
//  TakeHome
//
//  Created by Le on 16/5/25.
//

import CoreData

class UserRepository {
    let context: NSManagedObjectContext

    // Initialize UserRepository with the Core Data context
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // Save users to Core Data with order
    func saveUsers(_ users: [UserInformationModel]) throws {
        for (index, user) in users.enumerated() {
            let userEntity = UserEntity(context: context)
            userEntity.login = user.login
            userEntity.avatar_url = user.avatar_url
            userEntity.order = Int16(index)
        }
        
        do {
            try context.save()
        } catch {
            throw error
        }
    }

    func fetchUsers() throws -> [UserEntity] {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            return try context.fetch(fetchRequest)
        } catch {
            throw error // Propagate the error if fetching fails
        }
    }
}

