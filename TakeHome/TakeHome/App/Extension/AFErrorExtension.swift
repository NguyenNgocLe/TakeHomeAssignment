//
//  CustomErrorExtension.swift
//  TakeHome
//
//  Created by Le on 17/5/25.
//

import Foundation
import Alamofire

extension AFError {
    func mapToCustomError(responseData data: Data?) -> CustomError {
        switch self {
        case let .sessionTaskFailed(error):
            if let error = error as? URLError,
               error.code == URLError.notConnectedToInternet {
                return .noInternet
            }
        case .responseSerializationFailed:
            return .serialization
        case let .responseValidationFailed(reason):
            switch reason {
            case let .unacceptableStatusCode(code):
                switch code {
                case 400:
                    if let data = data,
                       let error = try? JSONDecoder().decode(ErrorResponse.self, from: data),
                       let code = error.errorCode {
                        return .knownError(errorCode: code)
                    }
                default:
                    break
                }
            default:
                break
            }
        case .explicitlyCancelled:
            return .explicitlyCancelled
        default:
            break
        }
        return .unknownError
    }
}
