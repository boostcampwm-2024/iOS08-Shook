import Foundation
import ProjectDescription

public enum GenerationEnvironment : String {
    case ci = "CI"
    case dev = "DEV"
}

// 환경변수 받기
let tuistEnv = ProcessInfo.processInfo.environment["TUIST_ENV"] ?? ""
public let generationEnvironment = GenerationEnvironment(rawValue: tuistEnv) ?? .dev

public extension GenerationEnvironment {
    var scripts: [TargetScript] { // 환경변수에 따라 동작할 스크립트 구분
        switch self {
        
        case .ci:
                return []
            
        case .dev:
            return [.swiftLint]
        }
        
    }
}
