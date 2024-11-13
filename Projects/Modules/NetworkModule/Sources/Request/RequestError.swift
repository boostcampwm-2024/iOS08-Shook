import Foundation

enum RequestError: Error, LocalizedError {
    case missingURL
    case jsonSerializationFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .missingURL:
            return "요청에서 유효한 URL을 찾을 수 없습니다."
        case .jsonSerializationFailed(let error):
            return "JSON 직렬화에 실패했습니다: \(error.localizedDescription)"
        }
    }
}
