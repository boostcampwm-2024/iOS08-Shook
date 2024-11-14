import XCTest

final class MockURLProtocol: URLProtocol {
    override static func canInit(with request: URLRequest) -> Bool { true }
    override static func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    static var requestHandler: ((URLRequest) throws -> (Data, HTTPURLResponse))?
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            return XCTFail("RequestHandler 가 없습니다.")
        }
        
        do {
            let (data, response) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}
