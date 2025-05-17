//
//  CustomError.swift
//  TakeHome
//
//  Created by Le on 17/5/25.
//

import Foundation
import Alamofire

struct ErrorResponse: Codable {
    let message: String?
    let errorCode: String?

    private enum CodingKeys: String, CodingKey {
        case message
        case errorCode = "error_code"
    }
}

enum CustomError: Error, Equatable {
    case noInternet
    case knownError(errorCode: String)
    case serialization
    case unknownError
    case explicitlyCancelled

    var description: String {
        switch self {
        case .noInternet:
            return "There is no internet connection."
        case let .knownError(errorCode):
            return CommonString.getErrorMessage(for: errorCode) ?? "Unknown error."
        case .serialization:
            return "Please try again later."
        case .explicitlyCancelled:
            return "The request is canceled"
        case .unknownError:
            return "We are facing difficulty, please try again later."
        }
    }

    var localizedDescription: String { description.localized }
}

