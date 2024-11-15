import Foundation

public protocol Interceptor {
    func prepare(_ request: URLRequest, from endpoint: Endpoint) throws -> URLRequest
    func willRequest(_ request: URLRequest, from endpoint: Endpoint) throws
    func didRecieve(_ response: Response, from endpoint: Endpoint) throws
}

public extension Interceptor { // optinal로 구현하기 위해
    func prepare(_ request: URLRequest, from endpoint: Endpoint) throws -> URLRequest { request }
    func willRequest(_ request: URLRequest, from endpoint: Endpoint) throws { }
    func didRecieve(_ response: Response, from endpoint: Endpoint) throws { } 
}
