import Foundation
import OSLog

#if DEBUG

public final class DefaultLoggingInterceptor: Interceptor {
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "NETWORK")
        
    public func willRequest(_ request: URLRequest, from endpoint: any Endpoint) throws {
        guard let url = request.url else { throw NetworkError.invaildURL }
        let method = endpoint.method
        
        var log = "====================\n\n[\(method)] \(url)\n\n====================\n"
        log.append("✅ Endpoint: \(endpoint)\n")
        
        log.append( "------------------- Header -------------------\n")
        if let header = endpoint.header, !header.isEmpty {
            log.append("✅ Header: \(header)\n")
        }
        log.append( "------------------- Header END -------------------\n")
        
        if let body = request.httpBody, !body.isEmpty, let bodyString = String(bytes: body, encoding: .utf8) {
            log.append("✅ Body: \(bodyString)\n")
        }
                
        log.append("------------------- END \(method) --------------------------\n")
        logger.log(level: .debug, "\(log)")
    }
    
    public func didRecieve(_ result: Response, from endpoint: any Endpoint) throws {
        
        guard let httpResponse = result.response as? HTTPURLResponse else {
            throw NetworkError.invaildResponse
        }
        
        switch httpResponse.statusCode {
        case endpoint.validationCode:
            onSucceded(result, from: endpoint)
            
        default:
            onFail(result, from: endpoint)
        }
        
    }
    
}

private extension DefaultLoggingInterceptor {
    func onSucceded(_ result: Response, from endpoint: any Endpoint) {
        let request = result.request
        let url = request.url?.absoluteString ?? "nil"
        guard let httpResponse = result.response as? HTTPURLResponse else { return }
        let statusCode = httpResponse.statusCode
        
        var log = "------------------- 네트워크 통신 성공 -------------------"
        log.append("\n[✅ Status Codee: \(statusCode)] \(url)\n----------------------------------------------------\n")
        log.append("✅ Endpoint: \(endpoint)\n")
        
        log.append( "------------------- Header -------------------\n")
        httpResponse.allHeaderFields.forEach {
            log.append("\($0): \($1)\n")
        }
        log.append( "------------------- Header END -------------------\n")
        
        log.append( "------------------- Body -------------------\n")
        if let resDataString = String(bytes: result.data, encoding: String.Encoding.utf8) {
            log.append("\(resDataString)\n")
        }
        log.append( "------------------- Body END -------------------\n")
        
        log.append("------------------- END HTTP (\(result.data.count)-byte body) -------------------\n")
        logger.log(level: .debug, "\(log)")
    }
    
    func onFail(_ result: Response, from endpoint: any Endpoint) {
        guard let httpResponse = result.response as? HTTPURLResponse else { return }
        let statusCode = httpResponse.statusCode
        let error = HTTPError(statuscode: statusCode)
        
        var log = "네트워크 오류"
        log.append("<-- ❌ \(statusCode) \(error) \(endpoint)\n")
        log.append("<-- END HTTP\n")

        logger.log(level: .error, "\(log)")
    }
}

#endif
