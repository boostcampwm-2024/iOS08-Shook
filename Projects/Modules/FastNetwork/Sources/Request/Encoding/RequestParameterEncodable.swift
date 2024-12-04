import Foundation

public typealias Parameters = [String: Any]

// MARK: - RequestParameterEncodable

public protocol RequestParameterEncodable {
    func encode(request: inout URLRequest, with parameters: Parameters) throws
}
