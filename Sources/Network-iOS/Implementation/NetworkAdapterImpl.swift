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
    
    try validateResponse(response, data: data)
    return try await data.decode(type, data)
  }
  
  /// API 요청 with Token
  public func requestAPIWithJWTToken<D: Decodable>(
    _ type: D.Type,
    request: URLRequest
  ) async throws -> D {
    var newRequest = request
    newRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let (data, response) = try await session.data(for: newRequest)
    
    return try await intercepter(type, originData: data, originResponse: response, request: newRequest) { request in
      let (data, _) = try await self.session.data(for: request)
      return try await data.decode(type, data)
    }
  }
  
  /// Image/File
  public func requestMultipart<D: Decodable>(
    _ type: D.Type,
    request: URLRequest,
    multipartFormData: MultipartFormData
  ) async throws -> D {
    var newRequest = request
    newRequest.addValue(
      multipartFormData.getHeader(multipartFormData.getBoundary()),
      forHTTPHeaderField: "Content-Type"
    )
    
    let multipartForm = multipartFormData.data

    guard !multipartForm.isEmpty else {
      throw NetworkError.multipartFormDataEmpty
    }
    
    let (data, response) = try await session.upload(for: newRequest, from: multipartForm)
    try validateResponse(response, data: data)
    return try await data.decode(type, data)
  }
  
  /// Image/File with Token
  public func requestMultipartWithJWTToken<D: Decodable>(
    _ type: D.Type,
    request: URLRequest,
    multipartFormData: MultipartFormData
  ) async throws -> D {
    var newRequest = request
    newRequest.addValue(
      multipartFormData.getHeader(multipartFormData.getBoundary()),
      forHTTPHeaderField: "Content-Type"
    )
    
    let multipartForm = multipartFormData.data

    guard !multipartForm.isEmpty else {
      throw NetworkError.multipartFormDataEmpty
    }
    
    let (data, response) = try await session.upload(for: newRequest, from: multipartForm)
    
    return try await intercepter(type, originData: data, originResponse: response, request: newRequest) { request in
      let (data, _) = try await self.session.upload(for: request, from: multipartForm)
      return try await data.decode(type, data)
    }
  }
  
  /// URL to Image
  public func requestImage(imageURLRequest: URLRequest) async throws -> Data {
    let (data, _) = try await session.data(for: imageURLRequest)
    return data
  }
  
  // MARK: - Helpers
  
  /// Respons 유효성 검사
  func validateResponse(_ response: URLResponse, data: Data) throws {
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.httpResponseTypeCastingFailed
    }
    
    guard validate(statusCode: httpResponse.statusCode) else {
      throw NetworkError.invalidHttpStatusCode(
        statusCode: httpResponse.statusCode,
        responseBody: data
      )
    }
  }
  
  /// Statust Code 유효성 검사
  @discardableResult
  public func validate<S: Sequence>(
    _ sequence: S = 200..<300,
    statusCode: Int
  ) -> Bool where S.Iterator.Element == Int {
    sequence.contains(statusCode)
  }
  
  /// ReIssue Handling
  private func intercepter<D: Decodable>(
    _ type: D.Type,
    originData: Data,
    originResponse: URLResponse,
    request: URLRequest,
    requestHandler: @escaping (URLRequest) async throws -> D
  ) async throws -> D {
    guard let httpResponse = originResponse as? HTTPURLResponse else {
      throw NetworkError.httpResponseTypeCastingFailed
    }
    
    let resultCode = getResultCode(with: originData)
    let shouldRefresh = reissueType == .resultCode ?
    ReissueType.isinvalidResultCode(resultCode) :
    httpResponse.statusCode == 401
    
    guard shouldRefresh else { return try await originData.decode(type, originData) }
    
    let code = reissueType == .resultCode ? resultCode : 401
    let newToken = reissue(code)
    
    guard !newToken.isEmpty else { return try await originData.decode(type, originData) }
    
    let newRequest = makeNewURLRequest(
      newToken: newToken,
      origin: request
    )
    
    return try await requestHandler(newRequest)
  }
  
  /// JWT Token Reissue 조건 확인을 위한 ResultCode 파싱
  private func getResultCode(with data: Data) -> Int {
    do {
      return try JSONDecoder().decode(ReissueResponse.self, from: data).resultCode
    } catch {
      return .zero
    }
  }
  
  /// JWT Token Reissue 로직 이후 새로운 URL Request 생성
  private func makeNewURLRequest(
    newToken: String,
    origin request: URLRequest
  ) -> URLRequest {
    let auth = "Authorization"
    var newRequest = request
    
    newRequest.allHTTPHeaderFields?.forEach {
      $0.key == auth ?
      newRequest.setValue("Bearer \(newToken)", forHTTPHeaderField: auth) :
      newRequest.setValue($0.value, forHTTPHeaderField: $0.key)
    }
    return newRequest
  }
  
}

