import Foundation

public extension URL {
    init(from endpoint: Endpoint) throws {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        guard let url = urlComponents.url else {
            throw NetworkError.invaildURL
        }
        
        self = url
    }
}
