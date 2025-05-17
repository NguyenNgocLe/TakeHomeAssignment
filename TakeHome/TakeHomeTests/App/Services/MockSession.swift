//
//  MockSession.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

import Testing
import Alamofire
@testable import TakeHome

final class MockSession: CustomSession {
    var endPoint: String?
    var expectedDataType: String?
    var method: HTTPMethod?
    var parameters: Parameters?

    var overrideResponses: [String: Result<Any, CustomError>] = [:]
    override func request<T>(endPoint: String,
                             expectedDataType: T.Type,
                             method: HTTPMethod,
                             parameters: Parameters?,
                             encoding: ParameterEncoding,
                             completion: @escaping (Result<T, CustomError>) -> Void) -> DataRequest where T: Decodable {
        if let response = overrideResponses[endPoint] {
            switch response {
                case .success(let value):
                    completion(.success(value as! T))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
        return super.request(endPoint: endPoint, expectedDataType: expectedDataType, method: method, parameters: parameters, encoding: encoding, completion: completion)
    }
}
