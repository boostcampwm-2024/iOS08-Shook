import Foundation

public struct URLQueryEncoder: RequestParameterEncodable {
    
#warning("배열 query value는 추후 구현")
    func encode(request: inout URLRequest, with parameters: Parameters) throws {
        #warning("return을 에러로 교체")
        guard let url = request.url else { return }
        
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

extension RequestParameterEncodable where Self == URLQueryEncoder {
    static func query() -> URLQueryEncoder {
        URLQueryEncoder()
    }
}
