//
//  NetworkProvider.swift
//  Shook
//
//  Created by inye on 11/4/24.
//

import Foundation

/// API 호출 및 데이터 통신을 담당합니다.
protocol NetworkProviderInterface {
    /// 요청을 수행하고 응답 데이터를 반환하는 메서드
    ///  - Parameters: 요청 메시지
    ///  - Throws
    ///    - 요청이 정상적이지 않은 경우 발생
    ///    - 응답이 정상적이지 않은 경우 발생
    ///  - Returns: 응답 Data
    @discardableResult
    func request(of requestMessage: some RequestMessage) async throws -> Data
}

/// 네트워크를 담당합니다.
final class NetworkProvider: NetworkProviderInterface {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request(of requestMessage: some RequestMessage) async throws -> Data {
        do {
            let urlRequest = try makeURLRequest(from: requestMessage)
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.responseNotHTTP
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let statusCode = HTTPResponseStatusCode(rawValue: httpResponse.statusCode)
                let invalidServerResponseError = NetworkError.invalidServerResponse(code: statusCode)
                throw invalidServerResponseError
            }
            
            return data
        } catch NetworkError.invalidURLString {
            throw NetworkError.invalidURLString
        }
    }
    
    // MARK: About URLRequest
    private func makeURLRequest(from requestMessage: some RequestMessage) throws -> URLRequest {
        guard let url = requestMessage.url else { throw NetworkError.invalidURLString }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestMessage.httpMethod.rawValue
        requestMessage.headers?.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        urlRequest.httpBody = requestMessage.body
        
        return urlRequest
    }
}
