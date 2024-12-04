import Foundation

public extension URL {
    init(from endpoint: Endpoint) throws {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.port = endpoint.port
        #warning("포트 번호 추후 삭제")

        guard let url = urlComponents.url else {
            throw NetworkError.invaildURL
        }

        self = url
    }
}
