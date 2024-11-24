import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers
import EnvironmentPlugin

let project = Project.module(
    name: ModulePaths.Feature.MainFeature.rawValue,
    targets: [
        .implements(module: .feature(.MainFeature), dependencies: [
            .feature(target: .BaseFeature)
        ]),
        .tests(module: .feature(.MainFeature), dependencies: [
            .feature(target: .MainFeature)
        ]),
        .demo(module: .feature(.MainFeature), dependencies: [
            .feature(target: .MainFeature)
        ])
    ]
)
