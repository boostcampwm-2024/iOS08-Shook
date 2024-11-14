import Foundation

public struct Response: Equatable, Hashable {
    public let request: URLRequest
    public let data: Data
    public let response: URLResponse
}
