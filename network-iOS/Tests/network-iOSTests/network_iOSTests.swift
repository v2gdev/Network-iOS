import XCTest
@testable import network_iOS

final class network_iOSTests: XCTestCase {
    
    private var sut: NetworkAdapter!
    
    override func setUpWithError() throws {
        sut = NetworkAdapterImpl()
        
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }
    
    func test_API_잘_생성되는지() {
      
    }
    
    func test_request_잘_보내지는지() {
        
    }
    
    func test_이미지_잘_보내지는지() {
        
    }
    
}
