import Foundation
import NetworkModule

let mockSuccessResponse = HTTPURLResponse(
    url: URL(string: "www.example.com")!,
    statusCode: 200,
    httpVersion: nil,
    headerFields: nil
)!

let mockBadRequestResponse = HTTPURLResponse(
    url: URL(string: "www.example.com")!,
    statusCode: 400,
    httpVersion: nil,
    headerFields: nil
)!

let mockBadGatewayResponse = HTTPURLResponse(
    url: URL(string: "www.example.com")!,
    statusCode: 502,
    httpVersion: nil,
    headerFields: nil
)!
