import Foundation
import UIKit

public typealias Parameters = [String: Any]

protocol RequestDataEncodable {
    func encode(request: inout URLRequest, with parameters: Parameters) throws
}
