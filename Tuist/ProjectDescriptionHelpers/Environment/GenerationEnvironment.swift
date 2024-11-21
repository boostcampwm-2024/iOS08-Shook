import Foundation
import ProjectDescription
import ConfigurationPlugin

public enum GenerationEnvironment : String {
    case ci = "CI"
    case dev = "DEV"
    case prod = "PROD"
}

// 환경변수 받기
let tuistEnv = ProcessInfo.processInfo.environment["TUIST_ENV"] ?? ""
public let generationEnvironment = GenerationEnvironment(rawValue: tuistEnv) ?? .dev

public extension GenerationEnvironment {
    var scripts: [TargetScript] { // 환경변수에 따라 동작할 스크립트 구분
        switch self {
            
        case .ci ,.prod:
            return []
            
        case .dev:
            return [.swiftLint]
        }
    }
    
    var configurations: [Configuration] {
        switch self {
        case .ci:
            return [
                .debug(name: .debug),
                .release(name: .release)
            ]
        case .dev, .prod:
            return .default
        }
    }
}
