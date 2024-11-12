import ProjectDescription
import DependencyPlugin

public extension TargetScript {
    static let swiftLint = TargetScript.pre(path: .scripts + "/SwiftLintRunScript.sh" , name: "SwiftLint", basedOnDependencyAnalysis: false)
}
