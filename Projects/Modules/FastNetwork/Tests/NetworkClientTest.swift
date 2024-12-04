import XCTest

@testable import FastNetwork
@testable import FastNetworkTesting

final class NetworkClientTest: XCTestCase {
    private var interceptors: [any Interceptor]!
    private var client: NetworkClient<MockEndpoint>!

    override func setUp() {
        super.setUp()
        interceptors = [DefaultLoggingInterceptor()]
        let configuration = URLSessionConfiguration.ephemeral // 일시적인
        configuration.protocolClasses = [MockURLProtocol.self] // URLProtocol subclasses 등록
        let session = URLSession(configuration: configuration)
        client = NetworkClient(session: session, interceptors: interceptors)
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

    func test_query_and_body_withParams() async throws {
        MockURLProtocol.mockData = mockData
        MockURLProtocol.mockResponse = mockSuccessResponse
        let mockEndpoint = MockEndpoint.getwithParameters(queryParams: ["sort": "asc"], bodyParams: ["age": 1])

        let response = try await client.request(mockEndpoint)
        guard let httpResponse = response.response as? HTTPURLResponse else { return XCTFail("HTTP 응답이 아닙니다.") }

        XCTAssertEqual(httpResponse.statusCode, 200)
        XCTAssertEqual(response.data, mockData)
    }
}
