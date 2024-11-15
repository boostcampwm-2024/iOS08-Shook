import Foundation

public struct Response: Hashable {
    public let request: URLRequest
    public let data: Data
    public let response: URLResponse
}
