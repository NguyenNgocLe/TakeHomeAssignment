//
//  ListUserViewModel.swift
//  TakeHome
//
//  Created by Le on 17/5/25.
//

import Foundation
import Alamofire

protocol ListUserViewModelType: BaseViewModelType, AnyObject {
    var getListUsersSuccessHandler: (() -> Void)? { get set }
    var getListUsersFailureHandler: ((CustomError) -> Void)? { get set }
    func fetchUsers()
    func getNumberOfRows() -> Int
    func getUser(at index: Int) -> UserInformationModel?
}

class ListUserViewModel: BaseViewModel, ListUserViewModelType {
    var getListUsersSuccessHandler: (() -> Void)?
    var getListUsersFailureHandler: ((CustomError) -> Void)?
    
    private let session: CustomSessionType
    
    private var data: [UserInformationModel] = []
    let userRepository: UserRepository
    
    // MARK: - Init
    init(userRepository: UserRepository, session: CustomSessionType = CustomSession.shared) {
        self.session = session
        self.userRepository = userRepository
        super.init()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchUsers() {
        Task {
            do {
                let localUsers = try loadUserDataFromLocal()
                if localUsers.isEmpty {
                    let params = [
                        "per_page": "20",
                        "since": "100"
                    ]
                    fetchUserInformation(params)
                } else {
                    CustomLogs.log("Core Data is not empty. using Data from Disk.")
                    updateModel(model: localUsers)
                    getListUsersSuccessHandler?()
                }
            } catch {
                self.getListUsersFailureHandler?(.unknownError)
            }
        }
    }
    
    private func updateModel(model: [UserInformationModel]) {
        self.data = model
    }
    
    /// Fetch API user information
    func fetchUserInformation(_ params: [String: String]) {
        session.request(endPoint: "", expectedDataType: [UserInformationModel].self,
                        method: .get, parameters: params,
                        encoding: URLEncoding.default) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case let .success(dataResponse):
                self.data = dataResponse
                do {
                    try saveUserData(self.data)
                } catch { }
                self.getListUsersSuccessHandler?()
            case .failure(let error):
                CustomLogs.log(error)
                self.getListUsersFailureHandler?(error)
            }
        }
    }
    
    func saveUserData(_ user: [UserInformationModel]) throws {
        try userRepository.saveUsers(user)
    }
    
    func loadUserDataFromLocal() throws -> [UserInformationModel] {
        let localUsers = try userRepository.fetchUsers()
        return localUsers.map {
            UserInformationModel(login: $0.login ?? "", avatar_url: $0.avatar_url ?? "")
        }
    }
    
    func deleteAllData() {
        CoreDataManager.shared.deleteAllUsers()
    }
    
    func getNumberOfRows() -> Int {
        return data.count
    }
    
    func getUser(at index: Int) -> UserInformationModel? {
        return data[safe: index]
    }
}
