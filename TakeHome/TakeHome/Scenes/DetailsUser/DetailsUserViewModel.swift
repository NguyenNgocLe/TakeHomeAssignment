//
//  DetailsUserViewModel.swift
//  TakeHome
//
//  Created by Le on 17/5/25.
//

import Foundation
import Alamofire

protocol DetailsUserViewModelType: BaseViewModelType, AnyObject {
    /// Closure when get Information Failed
    var getDataFailedHandler: ((CustomError) -> Void)? { get set }
    /// Closure when get All information Success
    var getAllInfoSuccess: ((DetailsUserModel) -> Void)? { get set }
    /// Fetch 3 API following, follower, and information
    /// After that notify response result to view controller and show data
    func getUserFollowingAndFollower() async
    /// Get user details model from previous
    func getUserDetailsModel() -> UserDetailsModel
}

class DetailsUserViewModel: BaseViewModel, DetailsUserViewModelType {
    var getDataFailedHandler: ((CustomError) -> Void)?
    
    var getUsersFollowerSuccessHandler: (() -> Void)?
    
    var getAllInfoSuccess:((DetailsUserModel) -> Void)?
    
    private let session: CustomSessionType
    var userDetailModel: UserDetailsModel
    
    init(session: CustomSessionType = CustomSession.shared, userDetailsModel: UserDetailsModel) {
        self.session = session
        self.userDetailModel = userDetailsModel
        super.init()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getUserFollowingAndFollower() async {
        do {
            async let followersResult = fetchCount(endPoint: "/\(userDetailModel.name)/followers",
                                                   failureHandler: getDataFailedHandler)
            async let followingsResult = fetchCount(endPoint: "/\(userDetailModel.name)/following",
                                                    failureHandler: getDataFailedHandler)
            async let informationUser = fetchInformation()
            let (numberFollower, numberFollowing, info) = try await (
                followersResult,
                followingsResult,
                informationUser
            )
            let details = DetailsUserModel(numberFollower: numberFollower, numberFollowing: numberFollowing,
                                           location: info.location ?? "", blog: info.blog ?? "")
            getAllInfoSuccess?(details)
        } catch {
            getDataFailedHandler?(error as? CustomError ?? .unknownError)
        }
    }
    
    private func fetchCount(endPoint: String, failureHandler: ((CustomError) -> Void)?) async -> Int {
        do {
            let count = try await withCheckedThrowingContinuation { continuation in
                session.request(endPoint: endPoint, expectedDataType: [FollowModel].self,
                                method: .get, parameters: nil, encoding: URLEncoding.default) { [weak self] response in
                    guard self != nil else { return }
                    switch response {
                    case let .success(data):
                        continuation.resume(returning: data.count)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }
            return count
        } catch {
            getDataFailedHandler?(error as? CustomError ?? .unknownError)
        }
        return 0
    }
    
    private func fetchInformation() async throws -> (location: String?, blog: String?) {
        try await withCheckedThrowingContinuation { continuation in
            session.request(endPoint: "/\(userDetailModel.name)",
                            expectedDataType: InformationUserModel.self,
                            method: .get, parameters: nil,
                            encoding: URLEncoding.default) { [weak self] response in
                guard self != nil else { return }
                switch response {
                case let .success(data):
                    continuation.resume(returning: (data.location ?? "VietNam", data.blog ?? ""))
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func getUserDetailsModel() -> UserDetailsModel {
        return userDetailModel
    }
}
