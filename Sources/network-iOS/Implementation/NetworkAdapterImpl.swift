//
//  Session.swift
//
//
//  Created by Jihee hwang on 4/23/24.
//

import Foundation

public final class NetworkAdapterImpl: NetworkAdapter {
  
  private let session: URLSession
  /// JWT Token 만료 판단 기준
  private let reissueType: ReissueType
  /// App과 주고 받을 Reissue 객체 - HTTP Status Code 혹은 Result Code를 전달하고, Access Token을 반환한다.
  private let reissue: (Int) -> String
  
  // MARK: - Initialize
  
  public init(
    session: URLSession = URLSession.shared,
    with reissueType: ReissueType,
    reissue: @escaping (Int) -> String
  ) {
    self.session = session
    self.reissueType = reissueType
    self.reissue = reissue
  }
  
  // MARK: - NetworkAdapter
  
  /// API 요청
  public func requestAPI<D: Decodable>(
    _ type: D.Type,
    request: URLRequest
  ) async throws -> D {
    var newRequest = request
    newRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let (data, response) = try await session.data(for: newRequest)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.httpResponseTypeCastingFailed
    }
    
    guard validate(statusCode: httpResponse.statusCode) else {
      throw NetworkError.invalidHttpStatusCode(
        statusCode: httpResponse.statusCode,
        responseBody: data
      )}
    
    return try await data.decode(type, data)
  }
  
  /// Header에 JWT Token이 실릴 경우 사용
  public func requestAPIWithJWTToken<D: Decodable>(
    _ type: D.Type,
    request: URLRequest
  ) async throws -> D {
    var newRequest = request
    newRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let (data, response) = try await session.data(for: newRequest)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.httpResponseTypeCastingFailed
    }
    
    if httpResponse.statusCode == 401 || getResultCode(with: data) {
      let result = try await requestAPI(type, request: getNewURLRequest(origin: request, response: httpResponse))
      return result
    }
    
    return try await data.decode(type, data)
  }
  
  /// Post or Delete Image/File
  public func requestMultipart<D: Decodable>(
    _ type: D.Type,
    request: URLRequest,
    multipartFormData: MultipartFormData
  ) async throws -> D {
    var request = request
    request.addValue(
      multipartFormData.getHeader(multipartFormData.boundary),
      forHTTPHeaderField: "Content-Type"
    )
    
    guard let multipartForm = multipartFormData.data else {
      throw NetworkError.multipartFormDataEmpty
    }
    
    let (data, _) = try await session.upload(for: request, from: multipartForm)
    return try await data.decode(type, data)
  }
  
  /// URL to Image
  public func requestImage(imageURLRequest: URLRequest) async throws -> Data {
    let (data, _) = try await session.data(for: imageURLRequest)
    return data
  }
  
  /// Statust Code 유효성 검사
  @discardableResult
  public func validate<S: Sequence>(
    _ sequence: S = 200..<300,
    statusCode: Int
  ) -> Bool where S.Iterator.Element == Int {
    sequence.contains(statusCode)
  }
  
  // MARK: - Helpers
  
  /// JWT Token Reissue 이후, URLRequest 재생성 및 재호출
  private func getNewURLRequest(
    origin request: URLRequest,
    response: HTTPURLResponse
  ) -> URLRequest {
    let auth = "Authorization"
    var newRequest = request
    newRequest.allHTTPHeaderFields?.removeAll()
    
    let newToken = reissueType == .statusCode ? reissue(401) : reissue(NetworkResultCode.jwtTokenExpired.rawValue)
    
    request.allHTTPHeaderFields?.forEach {
      if $0.key == auth {
        newRequest.addValue(newToken, forHTTPHeaderField: auth)
      }
      newRequest.addValue($0.value, forHTTPHeaderField: $0.key)
    }
    return newRequest
  }
  
  /// JWT Token Reissue 조건 확인을 위한 ResultCode 파싱
  private func getResultCode(with data: Data) -> Bool {
    do {
      let resultCode = try JSONDecoder().decode(ReissueResponse.self, from: data).resultCode
      let jwtTokenExpiredCode = NetworkResultCode.jwtTokenExpired.rawValue
      
      return resultCode == jwtTokenExpiredCode
    } catch {
      return false
    }
  }
}

