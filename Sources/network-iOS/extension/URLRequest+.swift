//
//  File.swift
//
//
//  Created by Jihee hwang on 5/2/24.
//

import Foundation

extension URLRequest: URLRequestConvertible {
  
  /// Body가 있는 경우
  public static func asURLRequest<E: Encodable>(
    api: URL,
    method: HTTPMethod,
    headers: HTTPHeaders?,
    body: E? = nil,
    timeout: TimeInterval = 30
  ) async throws -> URLRequest {
    var request = URLRequest(url: api)
    request.timeoutInterval = timeout
    request.httpMethod = method.rawValue
    request.httpBody = try await body?.toJson(body)
    request.allHTTPHeaderFields = headers?.dictionary
    return request
  }
  
  /// Body가 없는 경우
  public static func asURLRequest(
    api: URL,
    method: HTTPMethod,
    headers: HTTPHeaders?,
    timeout: TimeInterval = 30
  ) -> URLRequest {
    var request = URLRequest(url: api)
    request.timeoutInterval = timeout
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers?.dictionary
    return request
  }
  
  public static func asImageURLRequest(imageURL: URL) -> URLRequest {
    URLRequest(url: imageURL)
  }
  
}
