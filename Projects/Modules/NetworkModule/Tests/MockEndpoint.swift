import Foundation

import NetworkModule

enum MockEndpoint {
    case fetch
}

extension MockEndpoint: Endpoint {
    var method: NetworkModule.HTTPMethod {
        switch self {
        case .fetch: .get
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .fetch: nil
        }
    }
    
    var host: String { "www.example.com" }
    
    var path: String {
        switch self {
        case .fetch: return "/fetch"
        }
    }
    
    var requestTask: NetworkModule.RequestTask {
        switch self {
        case .fetch: .empty
        }
    }
}
