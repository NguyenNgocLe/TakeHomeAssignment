//
//  CustomSession.swift
//  TakeHome
//
//  Created by Le on 17/5/25.
//

import Foundation
import Alamofire

protocol CustomSessionType: AnyObject {
    @discardableResult
    func request<T: Decodable>(endPoint: String,
                               expectedDataType: T.Type,
                               method: HTTPMethod,
                               parameters: Parameters?,
                               encoding: ParameterEncoding,
                               completion: @escaping ((Result<T, CustomError>) -> Void)) -> DataRequest
    @discardableResult
    func request<T: Decodable>(url: URL,
                               expectedDataType: T.Type,
                               method: HTTPMethod,
                               parameters: Parameters?,
                               encoding: ParameterEncoding,
                               completion: @escaping ((Result<T, CustomError>) -> Void)) -> DataRequest
}

class CustomSession: Session, CustomSessionType {
    static let shared = CustomSession()
    private lazy var baseUrl: String = Environment.configuration(key: .baseUrl)
    
    @discardableResult
    func request<T: Decodable>(endPoint: String, expectedDataType: T.Type,
                               method: HTTPMethod, parameters: Parameters?,
                               encoding: ParameterEncoding,
                               completion: @escaping (Result<T, CustomError>) -> Void) -> DataRequest {
        guard let url = URL(string: handleUrlPath(endPoint: endPoint, baseUrl: baseUrl)) else {
            fatalError("URL is not valid")
        }
        return request(url: url,
                       expectedDataType: expectedDataType,
                       method: method,
                       parameters: parameters,
                       encoding: encoding,
                       completion: completion)
    }

    @discardableResult
    func request<T: Decodable>(url: URL, expectedDataType: T.Type,
                               method: HTTPMethod, parameters: Parameters?,
                               encoding: ParameterEncoding,
                               completion: @escaping (Result<T, CustomError>) -> Void) -> DataRequest {
        return request(url, method: method,
                       parameters: parameters, encoding: encoding,
                       headers: getDefaultHeader())
        .validate()
        .responseDecodable(of: T.self) { response in
            CustomLogs.log(response)
            switch response.result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error.mapToCustomError(responseData: response.data)))
            }
        }
    }
    
    private func getDefaultHeader() -> HTTPHeaders? {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json;charset=utf-8"
        ]
        return headers
    }

    
    func handleUrlPath(endPoint: String, baseUrl: String) -> String {
        var baseUrl = baseUrl
        if baseUrl.last == "/" {
            baseUrl.removeLast()
        }
        return baseUrl + endPoint
    }
}
