//
//  File.swift
//
//
//  Created by Jihee hwang on 6/3/24.
//

import Foundation

public enum NetworkResultCode: Int {
  case success = 100
  
  /// JWT Token 만료
  case jwtTokenExpired = 10010
  
  /// URL 형변환 에러
  case invalidURL = 20400
  /// String to Json 파싱 에러
  case jsonParsingFailed = 20401
  /// Network 연결 상태 에러
  case networkDisconnection = 20402
  /// Timeout 에러
  case timeout = 20403
  /// Response Body가 Json 형태가 아니거나,  null or Empty 인 경우
  case responseFaild = 20404
  /// Http Status Code가 200번대가 아닌 경우
  case invalidHttpStatusCode = 20405
  /// HTTPURLResponse Type Casting 에러 ‼️ ONLY iOS
  case httpResponseTypeCastingFailed = 20406
  /// multipartFormData가 nil일때 ‼️ ONLY iOS
  case multipartFormDataEmpty = 20408
  /// 알 수 없는 에러
  case unknown = 20409
}
