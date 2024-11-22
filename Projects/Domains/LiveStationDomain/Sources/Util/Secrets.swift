import Foundation

enum KeyKind: String {
    case secretKey = "SECRET_KEY"
    case accessKey = "ACCESS_KEY"
}

func config(key: KeyKind) -> String {
    guard let secrets = Bundle.main.object(forInfoDictionaryKey: "SECRETS") as? [String: Any] else {
        print("NO SECRETS")
        return ""
    }
    return secrets[key.rawValue] as? String ?? "not found key"
}
