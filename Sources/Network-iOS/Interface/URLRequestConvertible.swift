//
//  File.swift
//
//
//  Created by Jihee hwang on 5/2/24.
//

import Foundation

public protocol URLRequestConvertible {
  /// Body가 있는 경우
  static func asURLRequest<E: Encodable>(api: URL,
                                         method: HTTPMethod,
                                         headers: HTTPHeaders?,
                                         body: E?,
                                         timeout: TimeInterval
  ) async throws -> URLRequest
  
  /// Body가 없는 경우
  static func asURLRequest(api: URL,
                           method: HTTPMethod,
                           headers: HTTPHeaders?,
                           timeout: TimeInterval
  ) -> URLRequest
  
  /// String to ImageURL
  static func asImageURLRequest(imageURL: URL) -> URLRequest
}
