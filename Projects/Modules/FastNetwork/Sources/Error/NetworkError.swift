import Foundation

enum NetworkError: LocalizedError {
    case invaildURL
    case invaildResponse
    case jsonEncodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invaildURL: "유효한 URL을 찾을 수 없습니다."
        case .invaildResponse: "유효한 응답이 아닙니다."
        case let .jsonEncodingFailed(error): "JSON 인코딩에 실패했습니다: \(error.localizedDescription)"
        }
    }
}
