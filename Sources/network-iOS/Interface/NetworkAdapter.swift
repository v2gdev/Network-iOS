//
//  File.swift
//
//
//  Created by Jihee hwang on 4/22/24.
//

import Foundation

public protocol NetworkAdapter {
  /// 범용적인 API 요청
  func requestAPI<D: Decodable>(_ type: D.Type, request: URLRequest) async throws -> D
  /// Header에 JWT Token이 실릴 경우 사용
  func requestAPIWithJWTToken<D: Decodable>(_ type: D.Type, request: URLRequest) async throws -> D
  /// Post or Delete Image/File
  func requestMultipart<D: Decodable>(_ type: D.Type, request: URLRequest, multipartFormData: MultipartFormData) async throws -> D
  /// URL to Image // only iOS
  func requestImage(imageURLRequest: URLRequest) async throws -> Data
  /// 기본 범위인 200...500이 아닌 Code를 받으려는 경우 // only iOS
  func validate<S: Sequence>(_ sequence: S, statusCode: Int) -> Bool where S.Iterator.Element == Int
}
