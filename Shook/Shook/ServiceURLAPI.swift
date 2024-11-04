//
//  ServiceURLAPI.swift
//  Shook
//
//  Created by inye on 11/4/24.
//

import Foundation
import CommonCrypto

enum ServiceURLAPI {
    case getThumbnail
    static let accessKey = "{accessKey}"
    static let secretKey = "{secretKey}"
    
    func makeSignature() -> String? {
        let space = " "
        let newLine = "\n"
        let method = "GET"
        let url = "/api/v2/channels/ls-20241104161625-U8F0b/serviceUrls?serviceUrlType=THUMBNAIL"
        let accessKey = ServiceURLAPI.accessKey
        let secretKey = ServiceURLAPI.secretKey
        let timestamp = String(Int(Date().timeIntervalSince1970 * 1000))  // 밀리초 단위 타임스탬프

        // 메시지 생성
        let message = "\(method)\(space)\(url)\(newLine)\(timestamp)\(newLine)\(accessKey)"

        // HMAC SHA256으로 서명 생성
        guard let keyData = secretKey.data(using: .utf8),
              let messageData = message.data(using: .utf8) else {
            return nil
        }

        var hmac = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        messageData.withUnsafeBytes { messageBytes in
            keyData.withUnsafeBytes { keyBytes in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), keyBytes.baseAddress, keyData.count, messageBytes.baseAddress, messageData.count, &hmac)
            }
        }

        let hmacData = Data(hmac)
        let base64Signature = hmacData.base64EncodedString()

        return base64Signature
    }
}

extension ServiceURLAPI: RequestMessage {
    var httpMethod: HTTPMethod {
        .get
    }
    
    var path: String {
        "/api/v2/channels/ls-20241104161625-U8F0b/serviceUrls"
    }
    
    var headers: [String : String]? {
        [
            "x-ncp-apigw-timestamp": String(Int(Date().timeIntervalSince1970 * 1000)),
            "x-ncp-iam-access-key": ServiceURLAPI.accessKey,
            "x-ncp-apigw-signature-v2": makeSignature()!,
            "Content-Type": "application/json",
            "x-ncp-region_code": "KR"
        ]
    }
    
    var body: Data? { nil }
    
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "livestation.apigw.ntruss.com"
        urlComponents.path = self.path
        urlComponents.queryItems = [
            URLQueryItem(name: "serviceUrlType", value: "THUMBNAIL")
        ]
        //urlComponents.percentEncodedQuery = ""
        guard let url = urlComponents.url else { return nil }
        return url
    }
}
