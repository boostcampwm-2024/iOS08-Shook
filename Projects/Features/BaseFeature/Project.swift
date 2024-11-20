import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.BaseFeature.rawValue,
    targets: [
        .interface(module: .feature(.BaseFeature)),
        .implements(module: .feature(.BaseFeature), dependencies: [
            .feature(target: .BaseFeature, type: .interface),
            .userInterface(target: .DesignSystem),
            .module(target: .ThirdPartyLibModule)
        ]),
        .testing(module: .feature(.BaseFeature), dependencies: [
            .feature(target: .BaseFeature, type: .interface)
        ]),
        .tests(module: .feature(.BaseFeature), dependencies: [
            .feature(target: .BaseFeature),
            .feature(target: .BaseFeature, type: .testing)
        ]),
        .demo(module: .feature(.BaseFeature), dependencies: [
            .feature(target: .BaseFeature),
            .feature(target: .BaseFeature, type: .testing)
        ])
    ]
)
