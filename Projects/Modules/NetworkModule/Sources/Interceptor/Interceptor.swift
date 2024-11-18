import Foundation

public protocol Interceptor {
    func prepare(_ request: URLRequest, from endpoint: Endpoint) throws -> URLRequest
    func willRequest(_ request: URLRequest, from endpoint: Endpoint) throws
    func didReceive(_ response: Response, from endpoint: Endpoint) throws
}

public extension Interceptor {
    func prepare(_ request: URLRequest, from endpoint: Endpoint) throws -> URLRequest { request }
    func willRequest(_ request: URLRequest, from endpoint: Endpoint) throws { }
    func didReceive(_ response: Response, from endpoint: Endpoint) throws { } 
}
