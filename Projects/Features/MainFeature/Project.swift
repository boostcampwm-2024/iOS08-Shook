import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers
import EnvironmentPlugin

let project = Project.module(
    name: ModulePaths.Feature.MainFeature.rawValue,
    targets: [
        .implements(module: .feature(.MainFeature), dependencies: [
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
