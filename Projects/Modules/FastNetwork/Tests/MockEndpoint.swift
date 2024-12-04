import Foundation

import FastNetwork

// MARK: - MockEndpoint

enum MockEndpoint {
    case fetch
    case getwithParameters(queryParams: [String: Any], bodyParams: [String: Any])
}

// MARK: Endpoint

extension MockEndpoint: Endpoint {
    var method: FastNetwork.HTTPMethod {
        switch self {
        case .fetch, .getwithParameters: .get
        }
    }

    var header: [String: String]? {
        switch self {
        case .fetch: nil

        case .getwithParameters:
            ["임시 헤더": "shookHeader"]
        }
    }

    var host: String { "www.example.com" }

    var path: String {
        switch self {
        case .fetch, .getwithParameters: "/fetch"
        }
    }

    var requestTask: FastNetwork.RequestTask {
        switch self {
        case .fetch: .empty

        case let .getwithParameters(queryParams, bodyParams):
            .withParameters(body: bodyParams, query: queryParams)
        }
    }

    var validationCode: ClosedRange<Int> { 200 ... 299 }
}
