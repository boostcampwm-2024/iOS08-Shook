import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.BaseFeature.rawValue,
    targets: [
        .interface(module: .feature(.BaseFeature)),
        .implements(module: .feature(.BaseFeature), dependencies: [
            .feature(target: .BaseFeature, type: .interface)
        ]),
        .testing(module: .feature(.BaseFeature), dependencies: [
            .feature(target: .BaseFeature, type: .interface)
        ]),
        .tests(module: .feature(.BaseFeature), dependencies: [
            .feature(target: .BaseFeature)
        ]),
        .demo(module: .feature(.BaseFeature), dependencies: [
            .feature(target: .BaseFeature)
        ])
    ]
)
