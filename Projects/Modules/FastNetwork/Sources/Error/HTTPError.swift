import Foundation

public enum HTTPError: String, LocalizedError {
    // MARK: 400..<500 , Client Error

    case badRequest // 400
    case unauthorized // 401
    case paymentRequired // 402
    case forbidden // 403
    case notFound // 404
    case methodNotAllowed // 405
    case conflict // 409

    // MARK: 500..<600 Server Error

    case internalServerError // 500
    case badGateway // 502

    // MARK: Extra

    case underlying

    init(statuscode: Int) {
        switch statuscode {
        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 402: self = .paymentRequired
        case 403: self = .forbidden
        case 404: self = .notFound
        case 405: self = .methodNotAllowed
        case 409: self = .conflict
        case 500: self = .internalServerError
        case 502: self = .badGateway
        default: self = .underlying
        }
    }

    public var errorDescription: String? { rawValue }
}
