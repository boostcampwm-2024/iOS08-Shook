import Foundation

import NetworkModuleInterface

final class MockURLSession: URLSessionProtocol {
    let data: Data
    let response: URLResponse
    
    init(data: Data, response: URLResponse) {
        self.data = data
        self.response = response
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        (data, response)
    }
}
