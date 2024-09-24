//
//  Reissue_iOSTests.swift
//
//
//  Created by Jihee hwang on 7/31/24.
//

import XCTest
@testable import Network_iOS

final class Reissue_iOSTests: XCTestCase {
  
  private var sut: NetworkAdapter!
  private var sut401: NetworkAdapter!
  private let resultCodeReissueMockServer = URL(string: "http://3.36.152.50:9800/api/mobile/service/app-version/result-code")
  private let statusCodeReissueMockServer = URL(string: "http://3.36.152.50:9800/api/mobile/service/app-version/status-code")
  private let authorizationHeader = HTTPHeader()
    .builder
    .set(\.name, to: "Authorization")
    .set(\.value, to: "AccessToken")
    .build()
  
  private let reissueHandler: (Int) -> String = { code in
    print("토큰 만료로 인해 새로운 토큰을 재발급합니다. 상태 코드: \(code)")
    return "newAccessToken" // 새로운 액세스 토큰 반환
  }
  
  override func setUpWithError() throws {
    sut = NetworkAdapterImpl(with: .resultCode, reissue: reissueHandler)
    sut401 = NetworkAdapterImpl(with: .statusCode, reissue: reissueHandler)
    
    try super.setUpWithError()
  }
  
  override func tearDownWithError() throws {
    sut = nil
    
    try super.tearDownWithError()
  }
  
  func test_Reissue_ResultCode_잘_되는지() {
    let expectation = self.expectation(description: "Reissue Test")
    
    Task {
      // Given
      guard let request = try await makeReissueURLRequest_ResultCode() else { return }
      
      do {
        // When
        let response = try await sut.requestAPIWithJWTToken(ReissueResponse.self, request: request).resultCode
        
        // Then
        XCTAssertEqual(response, NetworkResultCode.jsonParsingFailed.rawValue)
      } catch {
        print("요청 실패: \(error)")
      }
      
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
  func test_Reissue_401_잘_되는지() {
    let expectation = self.expectation(description: "Reissue Test")
    
    Task {
      // Given
      guard let request = try await makeReissueURLRequest_StatusCode() else { return }
      
      do {
        // When
        let response = try await sut.requestAPIWithJWTToken(ReissueResponse.self, request: request)
      
      } catch {
        // Then
        let e = error.asNetworkError
        XCTAssertEqual(e?.resultCode, NetworkResultCode.invalidHttpStatusCode)
      }
      
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 10, handler: nil)
  }
  
}

extension Reissue_iOSTests {
  
  /// Reissue Test를 위한 URLRequest 생성 - Result Code
  private func makeReissueURLRequest_ResultCode() async throws -> URLRequest? {
    
    guard let api = resultCodeReissueMockServer else {
      return nil
    }
    
    return URLRequest.asURLRequest(
      api: api,
      method: .get,
      headers: .init([authorizationHeader])
    )
  }
  
  /// Reissue Test를 위한 URLRequest 생성 - Status Code
  private func makeReissueURLRequest_StatusCode() async throws -> URLRequest? {
    
    guard let api = statusCodeReissueMockServer else {
      return nil
    }
    
    return URLRequest.asURLRequest(
      api: api,
      method: .get,
      headers: .init([authorizationHeader])
    )
  }
  
}
