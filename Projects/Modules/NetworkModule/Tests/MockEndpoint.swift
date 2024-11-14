import Foundation

import NetworkModule

enum MockEndpoint {
    case fetch
    case getwithParameters(queryParams: [String: Any], bodyParams: [String: Any])
}

extension MockEndpoint: Endpoint {
    var method: NetworkModule.HTTPMethod {
        switch self {
        case .fetch, .getwithParameters: .get
        }
    }
    
    var header: [String: String]? {
        switch self {
        case .fetch: nil
        
        case let .getwithParameters(_,_):
            ["임시 헤더" : "shookHeader"]
        }
    }
    
    var host: String { "www.example.com" }
    
    var path: String {
        switch self {
        case .fetch, .getwithParameters: return "/fetch"
        }
    }
    
    var requestTask: NetworkModule.RequestTask {
        switch self {
        case .fetch: .empty
        case let .getwithParameters(queryParams, bodyParams):
                .withParamteres(body: bodyParams, query: queryParams)
        }
    }
    
    var validationCode: ClosedRange<Int> { 200...299 }
}
