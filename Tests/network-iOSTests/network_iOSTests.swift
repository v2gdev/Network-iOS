import XCTest
@testable import network_iOS

final class network_iOSTests: XCTestCase {
  
  private var sut: NetworkAdapter!
  private var TermsAPIResponse: Terms_API.Response?
  
  override func setUpWithError() throws {
    sut = NetworkAdapterImpl()
    
    try super.setUpWithError()
  }
  
  override func tearDownWithError() throws {
    sut = nil
    
    try super.tearDownWithError()
  }
  
  func test_API_잘_생성되는지() {
    // Given
    let prepayAPI = APITarget.payment(.prepay).baseURL?.absoluteString
    
    // When
    let evServicePrepayAPI = "https://evs-chungguk-dev-api.autocrypt.io/mobile/payment/prepay"
    
    // Then
    XCTAssertEqual(prepayAPI, evServicePrepayAPI)
  }
  
  func test_request_잘_보내지는지() {
    // Given
    let api = APITarget.terms_list.baseURL!
    
    // When
    Task {
      await requestTermsList(api: api)
      
      // then
      XCTAssertNotNil(TermsAPIResponse)
    }
    
  }
  
  func test_QueryPrameter_잘_생성되는지() {
    // Given
    let queryPram: [URLQueryItem] = [
      .init(name: "test1", value: "queryItem1"),
      .init(name: "test2", value: "queryItem2")
    ]
    
    let prepayAPI = APITarget.payment(.prepay).baseURL?.appendingQueryItems(queryPram).absoluteString
    
    // When
    let evServicePrepayAPI = "https://evs-chungguk-dev-api.autocrypt.io/mobile/payment/prepay?test1=queryItem1&test2=queryItem2"
    
    // Then
    XCTAssertEqual(prepayAPI, evServicePrepayAPI)
  }
}

// Private Function
extension network_iOSTests {
  
  private func requestTermsList(api: URL) async {
    do {
      let response = try await sut.requestAPI(
        Terms_API.Response.self,
        request: .init(url: api)
      )
      TermsAPIResponse = response
    } catch {
      let arr = error as? URLError
      if arr?.code == .timedOut {
        fatalError(NetworkError.timeout.localizedDescription)
      }
    }
  }
  
}
