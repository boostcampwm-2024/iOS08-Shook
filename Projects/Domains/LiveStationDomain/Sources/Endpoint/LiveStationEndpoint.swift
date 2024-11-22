import CommonCrypto
import Foundation

import NetworkModule

public enum LiveStationEndpoint {
    case fetchChannelList
}

extension LiveStationEndpoint: Endpoint {
    public var method: NetworkModule.HTTPMethod {
        switch self {
        case .fetchChannelList:
            return .get
        }
    }
    
    public var header: [String: String]? {
        switch self {
        case .fetchChannelList:
            return [
                "x-ncp-apigw-timestamp": String(Int(Date().timeIntervalSince1970 * 1000)),
                "x-ncp-iam-access-key": config(key: .accessKey),
                "x-ncp-apigw-signature-v2": makeSignature(with: "GENERAL")!,
                "Content-Type": "application/json",
                "x-ncp-region_code": "KR"
            ]
        }
    }
    
    public var host: String {
        "livestation.apigw.ntruss.com"
    }
    
    public var path: String {
        switch self {
        case .fetchChannelList:
            return "/api/v2/channels"
        }
    }
    
    public var requestTask: NetworkModule.RequestTask {
        return .empty
    }
    
}

private extension LiveStationEndpoint {
    func makeSignature(with serviceUrlType: String) -> String? {
        let space = " "
        let newLine = "\n"
        let method = method
        let url = "/api/v2/channels"
        let accessKey = config(key: .accessKey)
        let secretKey = config(key: .secretKey)
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
