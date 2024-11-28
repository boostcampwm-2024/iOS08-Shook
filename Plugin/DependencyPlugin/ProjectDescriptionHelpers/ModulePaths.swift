import Foundation

public enum ModulePaths {
    case feature(Feature)
    case module(Module)
    case domain(Domain)
    case userInterface(UserInterface)
}

extension ModulePaths: ModularPathConvertable {
    public func targetName(type: MoudlarTargetType) -> String {
        switch self {
        case let .feature(module as any ModularPathConvertable),
            let .module(module as any ModularPathConvertable),
            let .domain(module as any ModularPathConvertable),
            let .userInterface(module as any ModularPathConvertable):
            return module.targetName(type: type)
        }
    }
}

public extension ModulePaths {
    enum Feature: String, ModularPathConvertable {
        case AuthFeature
        case LiveStreamFeature
        case MainFeature
        case BaseFeature
    }
}

public extension ModulePaths {
    enum Module: String, ModularPathConvertable {
        case ChatSoketModule
        case NetworkModule
        case EasyLayoutModule
        case ThirdPartyLibModule
    }
}

public extension ModulePaths {
    enum Domain: String, ModularPathConvertable {
        case BroadcastDomain
        case LiveStationDomain
        case BaseDomain
    }
}


public extension ModulePaths {
    enum UserInterface: String, ModularPathConvertable {
        case DesignSystem

    }
}

public enum MoudlarTargetType: String {
    case interface = "Interface"
    case sources = ""
    case testing = "Testing"
    case unitTest = "Tests"
    case demo = "Demo"
}

public protocol ModularPathConvertable {
    func targetName(type: MoudlarTargetType) -> String
}

public extension ModularPathConvertable where Self: RawRepresentable {
    func targetName(type: MoudlarTargetType) -> String {
        "\(self.rawValue)\(type.rawValue)"
    }
}
