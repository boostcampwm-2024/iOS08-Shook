import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.LiveStreamFeature.rawValue,
    targets: [
        .interface(module: .feature(.LiveStreamFeature)),
        .implements(module: .feature(.LiveStreamFeature), dependencies: [
            .feature(target: .LiveStreamFeature, type: .interface),
            .feature(target: .BaseFeature),
            .domain(target: .LiveStationDomain, type: .interface),
            .domain(target: .ChattingDomain, type: .interface)
        ]),
        .tests(module: .feature(.LiveStreamFeature), dependencies: [
            .feature(target: .LiveStreamFeature)
        ]),
        .demo(module: .feature(.LiveStreamFeature), dependencies: [
            .feature(target: .LiveStreamFeature)
        ])
    ]
)
