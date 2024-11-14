import XCTest

@testable import NetworkModule
@testable import NetworkModuleTesting

final class NetworkClientTest: XCTestCase {
    private var client: NetworkClient<MockEndpoint>!
    
    override func setUp() {
        super.setUp()
        URLProtocol.registerClass(MockURLProtocol.self)
        client = NetworkClient()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }

    // MARK: - Success
    func test_success_response() async throws {
        MockURLProtocol.mockData = mockData
        MockURLProtocol.mockResponse = mockSuccessResponse
        
        let mockEndpoint = MockEndpoint.fetch
        let response = try await client.request(mockEndpoint)
        let request = MockURLProtocol.mockRequest
        
        guard let httpResponse = response.response as? HTTPURLResponse else {
            return XCTFail("HTTP 응답이 아닙니다.")
        }
        
        XCTAssertEqual(request?.url?.absoluteString, "https://www.example.com/fetch")
        XCTAssertEqual(httpResponse.statusCode, 200)
        XCTAssertEqual(response.data, MockURLProtocol.mockData)
    }
    
    // MARK: - BadGateway
    func test_bad_gateway_response() async throws {
        MockURLProtocol.mockResponse = mockBadGatewayResponse
        let mockEndpoint = MockEndpoint.fetch

        var result: HTTPError?
        do {
            _ = try await client.request(mockEndpoint)
        } catch let error as HTTPError {
            result = error
        }

        let expectation = HTTPError.badGateway
        XCTAssertEqual(result, expectation)
    }

    // MARK: - BadRequest
    func test_bad_request_response() async throws {
        MockURLProtocol.mockResponse = mockBadRequestResponse
        let mockEndpoint = MockEndpoint.fetch

        var result: HTTPError?
        do {
            _ = try await client.request(mockEndpoint)
        } catch let error as HTTPError {
            result = error
        }

        let expectation = HTTPError.badRequest
        XCTAssertEqual(result, expectation)
    }
}
