import ProjectDescription

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
