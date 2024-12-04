import DependencyPlugin
import EnvironmentPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Feature.MainFeature.rawValue,
    targets: [
        .interface(module: .feature(.MainFeature)),
        .implements(module: .feature(.MainFeature), dependencies: [
            .feature(target: .MainFeature, type: .interface),
            .feature(target: .BaseFeature),
            .feature(target: .LiveStreamFeature, type: .interface),
            .domain(target: .LiveStationDomain, type: .interface),
            .domain(target: .BroadcastDomain, type: .interface)
        ]),
        .tests(module: .feature(.MainFeature), dependencies: [
            .feature(target: .MainFeature)
        ]),
        .demo(module: .feature(.MainFeature), dependencies: [
            .feature(target: .MainFeature)
        ])
    ]
)
