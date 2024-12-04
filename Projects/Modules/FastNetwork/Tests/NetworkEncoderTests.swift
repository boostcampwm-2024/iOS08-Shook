import XCTest

@testable import FastNetwork

private struct Body: Encodable {
    let name: String
}

final class NetworkEncoderTests: XCTestCase {
    let jsonEncoder: JSONEncoder = .init()
    
    func test_query_encoder() throws {
        var request = URLRequest(url: URL(string: "https://example.com")!)
        let encoder = URLQueryEncoder()
        
        try encoder.encode(request: &request, with: ["key1": "value1 ! #!@$**", "key2": 123, "key3": true])
        var components = URLComponents(string: "https://example.com")
        components?.queryItems = [
            URLQueryItem(name: "key1", value: "value1 ! #!@$**".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)),
            URLQueryItem(name: "key2", value: "\(123)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)),
            URLQueryItem(name: "key3", value: "\(true)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        XCTAssertEqual(request.url?.absoluteString.sorted(), components?.url?.absoluteString.sorted())
    }
    
    func test_json_encoder() throws {
        // 우리가 만든 인코더 이용
        var request1 = URLRequest(url: URL(string: "https://example.com")!)
        let encoder = ParamterJSONEncoder()
        try encoder.encode(request: &request1, with: ["name": "shook"])
        
        // struct + json ecoder 이용
        var request2 = URLRequest(url: URL(string: "https://example.com")!)
     
        let data = try jsonEncoder.encode(Body(name: "shook"))
        request2.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request2.httpBody = data
        
        XCTAssertEqual(request1, request2)
    }
    
}
