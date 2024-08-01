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
}

