//
//  File.swift
//
//
//  Created by Jihee hwang on 7/31/24.
//

import Foundation

public enum ReissueType {
  /// HTTP Status Code 401로 판단
  case statusCode
  /// Response DTO의 Result Code로 판단
  case resultCode
  
  static func isinvalidResultCode(_ resultCode: Int) -> Bool {
    let invaildResultCode = [10010, 10011, 10012, 10013, 10014, 10015]
    return invaildResultCode.contains(resultCode)
  }
}
