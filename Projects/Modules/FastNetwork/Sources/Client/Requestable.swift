import Foundation

protocol Requestable {
    associatedtype E: Endpoint

    func request(_ endpoint: E) async throws -> Response
}
