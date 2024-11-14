import Foundation

enum NetworkError: Error, LocalizedError {
    case invaildURL
    case jsonEncodingFailed(Error)
    case invaildResponse
    
    var errorDescription: String? {
        switch self {
        case .invaildURL:
            return "유효한 URL을 찾을 수 없습니다."
            
        case let .jsonEncodingFailed(error):
            return "JSON 인코딩에 실패했습니다: \(error.localizedDescription)"
            
        case .invaildResponse:
            return "유효한 응답이 아닙니다."
        }
    }
}
