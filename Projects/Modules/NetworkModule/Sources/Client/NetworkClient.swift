import Foundation

final class NetworkClient<E: Endpoint>: Requestable {
    func request(_ endpoint: E) async throws -> Response {
        let request = try configureURLRequest(from: endpoint)
        
        return try await requestNetworkTask(with: request, from: endpoint)
    }
}

private extension NetworkClient {
    func configureURLRequest(from endpoint: E) throws -> URLRequest {
        let requestURL = try URL(from: endpoint)
        
        #warning("캐싱 정책 나중에 설정")
        var request = URLRequest(url: requestURL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: endpoint.timeout)
        
        request.httpMethod = endpoint.method.rawValue
        
        try endpoint.requestTask.configureRequest(request: &request)
        request.allHTTPHeaderFields = endpoint.header
        
        return request
    }
    
    func requestNetworkTask(with request: URLRequest, from endpoint: E) async throws -> Response {
        
        let session = URLSession.shared
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.invaildResponse }
        
        let statusceCode = httpResponse.statusCode
        
        if !(endpoint.validationCode ~= statusceCode) {
            throw HTTPError(statuscode: statusceCode)
        }
    
        return Response(request: request, data: data, response: response)
    }
}
