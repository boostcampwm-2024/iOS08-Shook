import ProjectDescription

public extension TargetDependency {
    struct SPM {}
}

public extension TargetDependency.SPM {
    // MARK: external
    // ex) static let Moya = TargetDependency.external(name: "Moya")
    
    static let HaishinKit = TargetDependency.external(name: "HaishinKit")
 
}
