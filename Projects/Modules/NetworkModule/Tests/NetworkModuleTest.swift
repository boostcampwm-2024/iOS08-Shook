import XCTest
@testable import NetworkModule

final class NetworkModuleTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func test_query_encoder() throws {
        var request = URLRequest(url: URL(string: "https://example.com")!)
        let encoder = URLQueryEncoder()
        
        try encoder.encode(request: &request, with: ["key1": "value1 ! #!@$**", "key2": 123, "key3": true])
        
        XCTAssertEqual("\(request.url?.absoluteString)", "")
    }
}
