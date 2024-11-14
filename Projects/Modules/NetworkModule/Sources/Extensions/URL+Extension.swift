import Foundation

public extension URL {
    
    init(endpoint: Endpoint) throws {
        var urlComponets = URLComponents()
        urlComponets.scheme = endpoint.scheme
        urlComponets.host = endpoint.host
        urlComponets.path = endpoint.path
        
        guard let url = urlComponets.url else {
            throw RequestError.invaildURL
        }
        
        self = url
    }
}
