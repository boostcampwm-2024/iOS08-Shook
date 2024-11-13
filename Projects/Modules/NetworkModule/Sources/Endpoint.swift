import Foundation

public protocol Endpoint {
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var requestTask: RequestTask { get }
    var validationCode: ClosedRange<Int> { get }
    var timeout: TimeInterval { get }
}

public extension Endpoint {
    var validationCode: ClosedRange<Int> { 200...500 }
    var timeout: TimeInterval { 300 }
}