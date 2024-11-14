import XCTest

@testable import NetworkModule
@testable import NetworkModuleTesting

final class NetworkClientTest: XCTestCase {
    var session: URLSession!
    var client: NetworkClient<MockEndpoint>!
    
    override func setUp() {
        super.setUp()
        let configuartion = URLSessionConfiguration.ephemeral
        configuartion.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuartion)
        client = NetworkClient(session: session)
    }

    // MARK: - Success
    func test_success_response() async throws {
        let mockEndpoint = MockEndpoint.fetch
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString, "https://www.example.com/fetch")
            return (mockData, mockSuccessResponse)
        }
        let response = try await client.request(mockEndpoint)
        guard let httpResponse = response.response as? HTTPURLResponse else {
            return XCTFail("HTTP 응답이 아닙니다.")
        }
        
        XCTAssertEqual(httpResponse.statusCode, 200)
        XCTAssertEqual(response.data, mockData)
    }
}
