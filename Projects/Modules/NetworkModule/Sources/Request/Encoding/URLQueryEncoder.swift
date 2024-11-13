import Foundation

public struct URLQueryEncoder: RequestParameterEncodable {
    
    #warning("배열 query value는 추후 구현")
    func encode(request: inout URLRequest, with parameters: Parameters) throws {
        guard let url = request.url else { throw RequestError.missingURL }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)".urlQueryAllowed)
            }
            request.url = urlComponents.url
        }
    }
}

private extension String {
    var urlQueryAllowed: String? {
        self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
