import Foundation

import NetworkModuleInterface

public final class NetworkClient<E: Endpoint>: Requestable {
    private let session: URLSession
    private var interceptors: [any Interceptor]
    
    public init(session: URLSession = URLSession.shared, interceptors: [any Interceptor] = [] ) {
        self.session = session
        self.interceptors = interceptors
    }
    
    public func request(_ endpoint: E) async throws -> Response {
        var request = try configureURLRequest(from: endpoint)
        request = try interceptRequest(with: request, from: endpoint)
        return try await requestNetworkTask(with: request, from: endpoint)
    }
}

private extension NetworkClient {
    func configureURLRequest(from endpoint: E) throws -> URLRequest {
        let requestURL = try URL(from: endpoint)
        #warning("캐싱 정책 나중에 설정")
        var request = URLRequest(url: requestURL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: endpoint.timeout)
        
        request.httpMethod = endpoint.method.description
        
        try endpoint.requestTask.configureRequest(request: &request)
        request.allHTTPHeaderFields = endpoint.header
        
        return request
    }
    
    func requestNetworkTask(with request: URLRequest, from endpoint: E) async throws -> Response {
        let (data, urlResponse) = try await session.data(for: request)
        let response = Response(request: request, data: data, response: urlResponse)
        try interceptResponse(with: response, from: endpoint)
                
        guard let httpResponse = urlResponse as? HTTPURLResponse else { throw NetworkError.invaildResponse }
        
        let statusCode = httpResponse.statusCode
        
        if !(endpoint.validationCode ~= statusCode) {
            throw HTTPError(statuscode: statusCode)
        }
        
        return response
    }
    
    func interceptRequest(with request: URLRequest, from endpoint: E) throws -> URLRequest {
        var request = request
        
        for interceptor in self.interceptors {
            try interceptor.willRequest(request, from: endpoint)
            request = try interceptor.prepare(request, from: endpoint)
        }
        
        return request
    }
    
    func interceptResponse(with response: Response, from endpoint: E) throws {
        for interceptor in self.interceptors {
            try interceptor.didReceive(response, from: endpoint)
        }
    }
}
