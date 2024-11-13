import Foundation

public enum RequestTask {
    case empty
    case query(parameters: Parameters)
    case bodyByObject(object: any Encodable)
    case bodyByParameters(parameters: Parameters)
}
