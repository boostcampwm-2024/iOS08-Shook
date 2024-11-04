//
//  RequestMessage.swift
//  Shook
//
//  Created by inye on 11/4/24.
//

import Foundation

/// HTTP Request Message
protocol RequestMessage {
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var url: URL? { get }
}

/// HTTP Request Method
enum HTTPMethod: String {
    case get
    case post
    case delete
    
    var value: String {
        rawValue.uppercased()
    }
}
