import Foundation

public enum KeyKind: String {
    case secretKey = "SECRET_KEY"
    case accessKey = "ACCESS_KEY"
    case cdnDomain = "CDN_DOMAIN"
    case profileID = "PROFILE_ID"
    case cdnInstanceNo = "CDN_INSTANCE_NO"
    case port = "PORT"
    case host = "HOST"
}

public func config(key: KeyKind) -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "SECRETS") as? [String: Any] else {
        return ""
    }
    return secrets[key.rawValue] as? String ?? "not found key"
}
