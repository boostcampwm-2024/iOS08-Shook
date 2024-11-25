import CommonCrypto
import Foundation

import NetworkModule

public enum LiveStationEndpoint {
    case fetchChannelList
    case receiveBroadcast(channelId: String)
    ///썸네일
    ///채널 생성
    ///채널 삭제
}

extension LiveStationEndpoint: Endpoint {
    public var method: NetworkModule.HTTPMethod {
        switch self {
        case .fetchChannelList, .receiveBroadcast: .get
        }
    }
    
    public var header: [String: String]? {
        switch self {
        case .fetchChannelList, .receiveBroadcast:
            return [
                "x-ncp-apigw-timestamp": String(Int(Date().timeIntervalSince1970 * 1000)),
                "x-ncp-iam-access-key": config(key: .accessKey),
                "x-ncp-apigw-signature-v2": makeSignature(),
                "x-ncp-region_code": "KR"
            ]
        }
    }
    
    public var host: String {
        "livestation.apigw.ntruss.com"
    }
    
    public var path: String {
        switch self {
        case .fetchChannelList: "/api/v2/channels"
        case let .receiveBroadcast(channelId): "/api/v2/broadcasts/\(channelId)/serviceUrls"
        }
    }
    
    public var requestTask: NetworkModule.RequestTask {
        switch self {
        case .fetchChannelList:
            return .empty
        case .receiveBroadcast:
            return .withParameters(
                query: ["serviceUrlType": ServiceUrlType.general.rawValue]
            )
        }
    }
}

private extension LiveStationEndpoint {
    func makeQueryString(with query: Parameters) -> String {
        return "?" + query.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
    }
    
    func makeSignature() -> String {
        let space = " "
        let newLine = "\n"
        let method = method
        let accessKey = config(key: .accessKey)
        let secretKey = config(key: .secretKey)
        let timestamp = String(Int(Date().timeIntervalSince1970 * 1000))  // 밀리초 단위 타임스탬프
        
        var url = path
        switch requestTask {
        case .empty:
            break
        case let .withParameters(_, query, _, _), let .withObject(_, query, _):
            if let query {
                let queryString = makeQueryString(with: query)
                url.append(queryString)
            }
        }

        // 메시지 생성
        let message = "\(method)\(space)\(url)\(newLine)\(timestamp)\(newLine)\(accessKey)"

        // HMAC SHA256으로 서명 생성
        guard let keyData = secretKey.data(using: .utf8),
              let messageData = message.data(using: .utf8) else {
            return ""
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
