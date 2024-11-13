import Foundation

public enum RequestTask {
    case empty
    case query(parameters: [String: Any])
    case httpBody(data: any Encodable)
}
