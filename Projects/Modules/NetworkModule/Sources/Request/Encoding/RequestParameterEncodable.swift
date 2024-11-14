import Foundation
import UIKit

public typealias Parameters = [String: Any]

public protocol RequestParameterEncodable {
    func encode(request: inout URLRequest, with parameters: Parameters) throws
}
