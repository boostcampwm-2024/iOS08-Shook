//
//  NetworkError.swift
//  Shook
//
//  Created by inye on 11/4/24.
//

import Foundation

/// Network Error
enum NetworkError: LocalizedError {
    case invalidURLString
    case invalidServerResponse(code: HTTPResponseStatusCode?)
    case responseNotHTTP
    case urlDownloadsError
    
    var errorDescription: String? {
        switch self {
        case .invalidURLString:
            return "잘못된 URL"
        case let .invalidServerResponse(code):
            let base = "잘못된 응답 "
            if let code = code {
                return base + "\(code.rawValue)"
            } else {
                return base
            }
        case .responseNotHTTP:
            return "응답이 HTTP가 아님"
        case .urlDownloadsError:
            return "URL 콘텐츠 다운로드 에러"
        }
    }
}

enum HTTPResponseStatusCode: Int {
    // 2xx: 성공
    case received = 200
    case created = 201
    
    // 3xx: 리다이렉션
    case movedPermanently = 301
    
    // 4xx: 클라이언트 오류
    case badRequest = 400
    case forbidden = 403
    case notFound = 404
    case gone = 410
    case validationFailed = 422
    
    // 5xx: 서버 오류
    case serviceUnavailable = 503
    
    var description: String? {
        switch self {
        case .movedPermanently:
            return "요청한 리소스가 다른 URI로 영구적으로 이동되었습니다."
        case .badRequest:
            return "잘못된 요청입니다."
        case .forbidden:
            return "지정한 리소스에 대한 액세스가 금지되었습니다."
        case .notFound:
            return "요청한 리소스를 찾을 수 없습니다."
        case .gone:
            return "리소스의 기간이 만료되었습니다."
        case .validationFailed:
            return "처리할 수 없는 요청입니다."
        case .serviceUnavailable:
            return " 현재 서비스를 사용할 수 없습니다."
        default:
            return nil
        }
    }
}
