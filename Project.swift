import ProjectDescription
import ConfigurationPlugin

let project = Project(
    name: "IOS08Shook",
    targets: [
        .target(
            name: "IOS08Shook",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.IOS08Shook",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                ]
            ),
            sources: ["IOS08Shook/Sources/**"],
            resources: ["IOS08Shook/Resources/**"],
            scripts: [TargetScript.pre(path: Path.relativeToRoot("Scripts/SwiftLintRunScript.sh") , name: "SwiftLint", basedOnDependencyAnalysis: false)],
            dependencies: []
        ),
        .target(
            name: "IOS08ShookTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.IOS08ShookTests",
            infoPlist: .default,
            sources: ["IOS08Shook/Tests/**"],
            resources: [],
            dependencies: [.target(name: "IOS08Shook")]
        ),
    ]
)
