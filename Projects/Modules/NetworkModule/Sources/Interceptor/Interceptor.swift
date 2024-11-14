import Foundation

public protocol Interceptor {
    /// request를 보내기 전, 수정할 작업이 있을 경우 ex) token
    func prepare(_ request: URLRequest, from endpoint: Endpoint) throws -> URLRequest
    /// 보내기 직전 최종 request
    func willRequest(_ request: URLRequest, from endpoint: Endpoint) throws
    /// response 받았을 때
    func didRecieve(_ result: Response, from endpoint: Endpoint) throws
}

public extension Interceptor { // optinal로 구현하기 위해
    func prepare(_ request: URLRequest, from endpoint: Endpoint) throws -> URLRequest { request }
    func willRequest(_ request: URLRequest, from endpoint: Endpoint) throws { }
    func didRecieve(_ result: Response, from endpoint: Endpoint) throws { } 
}
