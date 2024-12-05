import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.AuthFeature.rawValue,
    targets: [
        .interface(module: .feature(.AuthFeature)),
        .implements(module: .feature(.AuthFeature), dependencies: [
            .feature(target: .AuthFeature, type: .interface),
            .feature(target: .BaseFeature),
        ]),
        .tests(module: .feature(.AuthFeature), dependencies: [
            .feature(target: .AuthFeature),
        ]),
        .demo(module: .feature(.AuthFeature), dependencies: [
            .feature(target: .AuthFeature),
        ]),
    ]
)
