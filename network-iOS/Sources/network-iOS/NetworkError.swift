//
//  NetworkError.swift
//  
//
//  Created by Jihee hwang on 4/23/24.
//

import Foundation

public enum NetworkError: Error {
    /// URL 형변환 에러
    case invalidURL(url: String)
    /// String to Json 파싱 에러
    case jsonParsingFailed
    /// Network 연결 상태 에러
    case networkDisconnection
    /// Timeout 에러
    case timeout
    /// Response Body가 Json 형태가 아니거나,  null or Empty 인 경우
    case responseFaild(statusCode: Int)
    /// Http Status Code가 200번대가 아닌 경우
    case invalidHttpStatusCode(statusCode: Int, responseBody: Data)
    /// HTTPURLResponse Type Casting 에러 ‼️ ONLY iOS
    case httpResponseTypeCastingFailed
    /// multipartFormData가 nil일때 ‼️ ONLY iOS
    case multipartFormDataEmpty
    /// 알 수 없는 에러
    case unknown(Error)
}

// MARK: - localizedDescription

extension NetworkError {
    var localizedDescription: String {
        switch self {
        case .invalidURL(let url):
            return "Invalid \(url)"
        case .jsonParsingFailed:
            return "Json Parsing Faild"
        case .networkDisconnection:
            return "Network Disconnection"
        case .timeout:
            return  "Time Out"
        case .responseFaild(let statusCode):
            return "API Response is Null. Statust Code is \(statusCode)"
        case .invalidHttpStatusCode(let statusCode, let responseBody):
            return "Invalid Http Status Code.\nStatust Code is \(statusCode).\nResponse Body is \(responseBody)"
        case .httpResponseTypeCastingFailed:
            return "Fail to HTTPURLResponse Type Casting"
        case .multipartFormDataEmpty:
            return "Empty MultipartFormData"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
