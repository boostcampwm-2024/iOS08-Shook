import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.LiveStreamFeature.rawValue,
    targets: [
        .interface(module: .feature(.LiveStreamFeature), dependencies: [
            .feature(target: .BaseFeature)
        ]),
        .implements(module: .feature(.LiveStreamFeature), dependencies: [
            .feature(target: .LiveStreamFeature, type: .interface)
        ]),
        .tests(module: .feature(.LiveStreamFeature), dependencies: [
            .feature(target: .LiveStreamFeature)
        ]),
        .demo(module: .feature(.LiveStreamFeature), dependencies: [
            .feature(target: .LiveStreamFeature)
        ])
    ]
)