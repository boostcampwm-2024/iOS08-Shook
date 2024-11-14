import Foundation

public extension URL {
    init(from endpoint: Endpoint) throws {
        var urlComponets = URLComponents()
        urlComponets.scheme = endpoint.scheme
        urlComponets.host = endpoint.host
        urlComponets.path = endpoint.path
        
        guard let url = urlComponets.url else {
            throw NetworkError.invaildURL
        }
        
        self = url
    }
}
