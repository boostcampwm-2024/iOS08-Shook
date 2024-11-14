import Foundation

enum RequestError: Error, LocalizedError {
    case missingURL
    case jsonEncodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .missingURL:
            return "요청에서 유효한 URL을 찾을 수 없습니다."
            
        case let .jsonEncodingFailed(error):
            return "JSON 인코딩에 실패했습니다: \(error.localizedDescription)"
        }
    }
}
